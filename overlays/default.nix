# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev: {
    # nest everything under a namespace that's not likely to collide
    # with anything in nixpkgs
    local-pkgs = import ../pkgs { pkgs = final; };
    # naersk = prev.callPackage inputs.naersk {};
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # TODO: fix. Seeing this
    # error: builder for '/nix/store/5mm2mnmm9bzmwmjnpxk9bixksvf087ax-rust-workspace-unknown.drv' failed with exit code 101;
    #    last 10 log lines:
    #    > warning: Both `/build/source/.cargo-home/config` and `/build/source/.cargo-home/config.toml` exist. Using `/build/source/.cargo-home/config`
    #    > error: failed to load manifest for workspace member `/build/source/repo-tests`
    #    >
    #    > Caused by:
    #    >   failed to parse manifest at `/build/source/repo-tests/Cargo.toml`
    #    >
    #    > Caused by:
    #    >   no targets specified in the manifest
    #    >   either src/lib.rs, src/main.rs, a [lib] section, or [[bin]] section must be present
    #    > [naersk] cargo returned with exit code 101, exiting
    #    For full logs, run 'nix log /nix/store/5mm2mnmm9bzmwmjnpxk9bixksvf087ax-rust-workspace-unknown.drv'.
    #
    # cargo-public-api = prev.naersk.buildPackage {
    #   src = prev.fetchFromGitHub {
    #     owner = "TroyNeubauer";
    #     repo = "cargo-public-api";
    #     rev = "b993fe8564d05277e94363f8dfaa1c8a3d56b2e3";
    #     hash = "sha256-SfY196hwfYH6qdPdt173UTUQ4ZLe2f3S2BJdfu4XLns=";
    #   };
    # };
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
