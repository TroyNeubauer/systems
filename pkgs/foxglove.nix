{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  glibc,
  gcc-unwrapped,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  x11basic,
  gtk3,
  pango,
  cairo,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  expat,
  libxcb,
  libxkbcommon,
  udev,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  atk,
  cups,
  libdrm,
  nspr,
  nss,
  mesa,
}:
let
  version = "2.22.0";
  src = fetchurl {
    url = "https://get.foxglove.dev/desktop/v2.28.1/foxglove-studio-2.28.1-linux-amd64.deb";
    hash = "sha256-6FD5sVA3Q6mBxICnlFiYa/h76/PASqSoUi2AqWQhNYg=";
  };
in
stdenv.mkDerivation {
  name = "foxglove-${version}";

  system = "x86_64-linux";

  inherit src;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    copyDesktopItems
  ];

  # Required at running time
  buildInputs = [
    glibc
    gcc-unwrapped
    x11basic
    gtk3
    pango
    cairo
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    expat
    libxcb
    libxkbcommon
    udev
    alsa-lib
    at-spi2-atk
    at-spi2-core
    dbus
    atk
    cups
    libdrm
    nspr
    nss
    mesa
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall
    # Create necessary directories
    mkdir -p $out/{bin,opt,share}
    # Copy main application files - handle space in directory name
    cp -r "opt/Foxglove" "$out/opt/"
    # Copy desktop integration files
    cp -r usr/share/applications $out/share/
    cp -r usr/share/icons $out/share/
    cp -r usr/share/mime $out/share/
    cp -r usr/share/doc $out/share/
    # Create symlink in bin directory
    ln -s "$out/opt/Foxglove/foxglove-studio" $out/bin/foxglove-studio
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "foxglove-studio";
      exec = "foxglove-studio";
      icon = "foxglove-studio";
      genericName = "Foxglove";
      desktopName = "Foxglove";
    })
  ];

  meta = with lib; {
    description = "Foxglove studio";
    homepage = "https://foxglove.dev/";
    license = licenses.mpl20;
    maintainers = with lib.maintainers; [ jerry8137 ];
    platforms = [ "x86_64-linux" ];
  };
}
