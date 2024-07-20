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
            ./nixos/machines/troys-macbook-air
          ];
        };
      };
    };
}
