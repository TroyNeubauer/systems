{
  description = "Home sweet home";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    home-manager,
    nixpkgs
  }:
    (flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      defaultApp = {
        type = "app";
	program = "${home-manager.packages.${system}.default}/bin/home-manager";
      };
    }))
    // (let
      homeManagerModules = {
        system,
	username,
	homeDirectory,
	stateVersion,
      }: let
        pkgs = nixpkgs.legacyPackages.${system};
      in [
        (import ./home.nix {
          inherit username homeDirectory stateVersion pkgs nixpkgs home-manager;
	})
      ];
    rawHomeManagerConfigurations = {
      "troy@battlestation" = {
        system = "x86_64-linux";
	username = "troy";
	host = "battlestation";
	homeDirectory = "/home/troy";
	stateVersion = "unstable";
      };
      "troyneubauer@Troys-MacBook-Air" = {
        system = "aarch64-darwin";
	username = "troyneubauer";
	host = "Troys-MacBook-Air";
	homeDirectory = "/Users/troyneubauer";
	stateVersion = "23.05";
      };
    };

    homeManagerConfiguration = {
      system,
      username,
      host,
      homeDirectory,
      stateVersion,
    }: (let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	modules = homeManagerModules { inherit system username homeDirectory stateVersion; };
      });
    in {
      # Export home-manager configurations
      inherit rawHomeManagerConfigurations;
      homeConfigurations = nixpkgs.lib.attrsets.mapAttrs
        (userAndHost: userAndHostConfig: homeManagerConfiguration userAndHostConfig)
      rawHomeManagerConfigurations;
    })
    // {
      inherit flake-utils home-manager nixpkgs;
    };
}
