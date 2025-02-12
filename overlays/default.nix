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
        owner = "cargo-public-api";
        repo = "cargo-public-api";
        rev = "ae6edf43d61b7ce5baec601195bf114d33b87a73";
        hash = "sha256-ewzfsvCvmAGPqnihVEK1Ahr0rAzSg5isA1KnVA5m8CI=";
      };

      # Let Cargo find libcurl (macos)
      nativeBuildInputs = [
        final.curl
        final.pkg-config
      ];
      doCheck = false;
    };
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
