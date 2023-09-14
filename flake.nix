{
  description = "Flake for systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
  let 
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      troy = nixpkgs.lib.nixosSystem {
        inherit system;
	specialArgs = { inherit inputs; };
	modules = [
	  ./configuration.nix
	  home-manager.nixosModules.home-manager
	  {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = { inherit inputs system; };
	    home-manager.users.troy = {
	      imports = [
	        ./home.nix
	      ];
	    };
	  }
	];

      };
    };
  };
}
