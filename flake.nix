{
  description = "Flake for systems";

  inputs = {
    home.url = "path:./home";
  };

  outputs = {
    self,
    home,
    ...
  }: let
    flake-utils = home.flake-utils;
    home-manager = home.home-manager;
    nixpkgs = home.nixpkgs;

  in (flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [age alejandra sops];
      };
    })
    // (let
      mapMachineConfigurations = nixpkgs.lib.mapAttrs (host: configuration:
        nixpkgs.lib.nixosSystem (
          let
            hmConfiguration = home.rawHomeManagerConfigurations."${configuration.user}@${host}";
	    lib = nixpkgs.lib;
          in {
            inherit (configuration) system;
            modules =
              configuration.modules
              ++ [
                home-manager.nixosModules.home-manager
                {
                  home-manager.users.${configuration.user} = import "${home}/home.nix" {
                    pkgs = nixpkgs.legacyPackages.${configuration.system};
                    inherit (home) home-manager nixpkgs;
                    inherit (hmConfiguration) username homeDirectory stateVersion lib;
                  };
                }
              ];
          }
        ));
    in {
      nixosConfigurations = mapMachineConfigurations {
        "battlestation" = {
          system = "x86_64-linux";
          user = "troy";
          modules = [
            ./configuration.nix
          ];
        };
      };
    }));
}
