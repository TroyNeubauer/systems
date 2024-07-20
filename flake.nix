{
  description = "My NixOS Config";
  # Structure based off of
  # https://github.com/Misterio77/nix-config/tree/main

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];

      mkNixos = modules: nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = { inherit inputs outputs; };
      };

      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    in
    rec {
      #nixosModules = import ./modules/nixos;
      # homeManagerModules = import ./modules/home-manager;
      #templates = import ./templates;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      # Devshell for bootstrapping
      devShells = forEachSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      nixosConfigurations = {
        # Main desktop (AMD 5950X) built fall '23
        battlestation = mkNixos [ ./nixos/machines/battlestation ];
        # 2023 m2 mac air
        hamono = mkNixos [ ./nixos/machines/hamono ];
        # BlueVPS tneubauer.xyz host
        tneubauerxyz = mkNixos [ ./nixos/machines/tneubauerxyz ];
      };
      homeConfigurations = {
        "battlestation" = home-manager.lib.homeManagerConfiguration {
          modules = [ ./home/machines/battlestation.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };
      darwinConfigurations = {
        "Troys-MacBook-Air" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.troyneubauer = import ./home.nix;

              # List packages installed in system profile. To search by name, run:
              # $ nix-env -qaP | grep wget
              # environment.systemPackages = [ pkgs.vim ];

              # Auto upgrade nix package and the daemon service.
              services.nix-daemon.enable = true;
              services.karabiner-elements.enable = true;
              # nix.package = pkgs.nix;

              # Necessary for using flakes on this system.
              nix.settings.experimental-features = "nix-command flakes";

              # Create /etc/zshrc that loads the nix-darwin environment.
              # programs.zsh.enable = true;  # default shell on catalina
              programs.fish.enable = true;

              # Used for backwards compatibility, please read the changelog before changing.
              # $ darwin-rebuild changelog
              system.stateVersion = 4;

              # The platform the configuration will be used on.
              nixpkgs.hostPlatform = "aarch64-darwin";

              users.users.troyneubauer = {
                  name = "troyneubauer";
                  home = "/Users/troyneubauer";
              };
            }
          ];
        };
      };
    };
}
