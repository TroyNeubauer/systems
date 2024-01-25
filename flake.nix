{
  description = "Flake for systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, apple-silicon, ... }:
    let
      inherit (nixpkgs.lib) nixosSystem;
      # pkgs = import nixpkgs {
      #   config.allowUnfree = true;
      #   inherit system;
      # };
      mkSystem = name: system: extraConfig: nixosSystem {
        inherit system;
        specialArgs = inputs;

        modules = [
          ./configuration.nix
          (./machines + "/${name}/configuration.nix")
          (./machines + "/${name}/hardware-configuration.nix")
          # home-manager.nixosModules.home-manager
          #   {
          #     home-manager.useGlobalPkgs = true;
          #     home-manager.useUserPackages = true;

          #     # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix

          #     home-manager.users.troy = import ./home/home.nix {
          #       # inherit pkgs;
          #       # pkgs = nixpkgs.legacyPackages."x86_64-linux";
          #       # inherit (home) nixpkgs;
          #     };
          #   }
        ] ++ [ extraConfig ];
      };
    in {
      nixosConfigurations = {
        battlestation = mkSystem "battlestation" "x86_64-linux" {};
        hamono = mkSystem "hamono" "aarch64-linux" {};
      };
    };
}
