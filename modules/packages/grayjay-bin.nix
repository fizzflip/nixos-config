{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  wrapGAppsHook3,
  copyDesktopItems,
  makeDesktopItem,
  glib,
  gtk3,
  nss,
  nspr,
  atk,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  cups,
  libdrm,
  expat,
  libxkbcommon,
  pango,
  cairo,
  systemdLibs,
  alsa-lib,
  libGL,
  libsecret,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxcb,
  mesa,
  zlib,
  openssl,
  krb5,
  icu,
}:
let
  rpathLibs = [
    icu
    (lib.getLib openssl)
    glib
    gtk3
    nss
    nspr
    atk
    at-spi2-atk
    at-spi2-core
    dbus
    cups
    libdrm
    expat
    libxkbcommon
    pango
    cairo
    systemdLibs
    alsa-lib
    libGL
    libsecret
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
    mesa
    zlib
    krb5
    stdenv.cc.cc.lib
  ];
in
stdenv.mkDerivation rec {
  pname = "grayjay-bin";
  version = "17";

  src = fetchurl {
    url = "https://updater.grayjay.app/Apps/Grayjay.Desktop/${version}/Grayjay.Desktop-linux-x64-v${version}.zip";
    hash = "sha256-KaW5U6JsMK8Q2voXJ7WI8Zzqk8dAc4gvp+HyqTNnV9Q=";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = rpathLibs;

  appendRunpaths = [
    "${icu}/lib"
    "${lib.getLib openssl}/lib"
    "${stdenv.cc.cc.lib}/lib"
  ];

  sourceRoot = ".";

  desktopItems = [
    (makeDesktopItem {
      name = "Grayjay";
      exec = "grayjay %U";
      icon = "grayjay";
      comment = "Cross platform media application for streaming and downloading media";
      desktopName = "Grayjay Desktop";
      categories = [ "AudioVideo" ];
      mimeTypes = [ "x-scheme-handler/grayjay" ];
    })
  ];

  installPhase = ''
        runHook preInstall

        mkdir -p $out/opt/grayjay
        cp -r Grayjay.Desktop-linux-x64-v${version}/* $out/opt/grayjay/

        # Remove portable flag so Grayjay uses ~/.local/share/Grayjay for user data and logs
        rm -f $out/opt/grayjay/Portable

        # Remove updater client since nix store is read-only
        rm -f $out/opt/grayjay/FUTO.Updater.Client

        # Temporary launch links expected by CEF
        ln -s /tmp/grayjay-launch $out/opt/grayjay/launch
        ln -s /tmp/grayjay-cef-launch $out/opt/grayjay/cef/launch

        # Ensure executable permissions
        chmod +x $out/opt/grayjay/Grayjay
        chmod +x $out/opt/grayjay/ffmpeg
        chmod +x $out/opt/grayjay/cef/dotcefnative
        chmod +x $out/opt/grayjay/cef/chrome-sandbox

        # Install desktop icons
        mkdir -p $out/share/icons/hicolor/512x512/apps
        mkdir -p $out/share/icons/hicolor/scalable/apps
        cp $out/opt/grayjay/grayjay.png $out/share/icons/hicolor/512x512/apps/grayjay.png
        cp $out/opt/grayjay/logo.svg $out/share/icons/hicolor/scalable/apps/grayjay.svg

        # Create launcher script in bin
        mkdir -p $out/bin
        cat > $out/bin/grayjay <<EOF
    #!/bin/sh
    mkdir -p "\$HOME/.local/share/Grayjay"
    cd "\$HOME/.local/share/Grayjay"
    exec $out/opt/grayjay/Grayjay "\$@"
    EOF
        chmod +x $out/bin/grayjay

        runHook postInstall
  '';

  postFixup = ''
    patchelf --add-rpath "${icu}/lib:${lib.getLib openssl}/lib:$out/opt/grayjay:$out/opt/grayjay/cef" $out/opt/grayjay/Grayjay
    patchelf --add-rpath "${icu}/lib:${lib.getLib openssl}/lib:$out/opt/grayjay:$out/opt/grayjay/cef" $out/opt/grayjay/cef/dotcefnative
  '';

  meta = {
    description = "Cross-platform application to stream and download content from various sources";
    homepage = "https://grayjay.app/desktop/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "grayjay";
  };
}
