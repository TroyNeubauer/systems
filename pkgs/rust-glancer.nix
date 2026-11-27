{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-glancer";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "rust-glancer";
    repo = "rust-glancer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Xr+VK82bFpc4Q7IDuk+DJioPt16KZoIyzgqIvO3a80=";
  };

  cargoHash = "sha256-fe9zNl2F+6/CNH7jDlEtmMTLajmwojsoZOcbGI3hIMw=";

  cargoBuildFlags = [ "-p" "rust-glancer" ];
  cargoTestFlags = [ "-p" "rust-glancer" ];

  meta = {
    description = "Rust language server that keeps its index on disk to stay under ~100MB of RAM";
    homepage = "https://github.com/rust-glancer/rust-glancer";
    changelog = "https://github.com/rust-glancer/rust-glancer/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit asl20 ];
    mainProgram = "rust-glancer";
  };
})
