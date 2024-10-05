# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev: {
    # nest everything under a namespace that's not likely to collide
    # with anything in nixpkgs
    local-pkgs = import ../pkgs { pkgs = final; };
    naersk = prev.callPackage inputs.naersk {};
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    cargo-public-api = prev.naersk.buildPackage {
      src = prev.fetchFromGitHub {
        owner = "TroyNeubauer";
        repo = "cargo-public-api";
        rev = "b993fe8564d05277e94363f8dfaa1c8a3d56b2e3";
        hash = "sha256-v8IiJKp2PZB3GK8+OdEa9NUCHeLgIMK+FYzjvcy4tK0=";
      };
    };
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
