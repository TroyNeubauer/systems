{
  description = "Home sweet home";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    flake-utils,
    home-manager,
    nixpkgs,
  }:
    (let
      pkgs = import <nixpkgs> {
        config = {
          allowUnfree = true;
        };
      };
      homeManagerModules = {
        system,
	username,
	homeDirectory,
	stateVersion,
	pkgs,
      }: let
        lib = home-manager.lib;
      in [
        (import ./home.nix {
          inherit username homeDirectory stateVersion pkgs nixpkgs home-manager lib;
	})
      ];
    rawHomeManagerConfigurations = {
      "troy@battlestation" = {
        system = "x86_64-linux";
	username = "troy";
	host = "battlestation";
	homeDirectory = "/home/troy";
	stateVersion = "23.05";
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
      pkgs,
    }: (home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	modules = homeManagerModules { inherit system username homeDirectory stateVersion; };
      });
    in {
      # Export home-manager configurations
      inherit rawHomeManagerConfigurations;

      homeConfigurations = nixpkgs.lib.attrsets.mapAttrs
        (userAndHost: userAndHostConfig: homeManagerConfiguration userAndHostConfig) rawHomeManagerConfigurations;
    })
    
    // {
      inherit flake-utils home-manager nixpkgs;
    };
}
