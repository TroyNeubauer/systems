{
  description = "Flake for systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        config.allowUnfree = true;
        inherit system;
      };
    in {
      nixosConfigurations = {
        battlestation = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix

              home-manager.users.troy = import ./home/home.nix {
                inherit pkgs;
                # pkgs = nixpkgs.legacyPackages."x86_64-linux";
                # inherit (home) nixpkgs;
              };
            }
          ];
        };
      };
    };
}
