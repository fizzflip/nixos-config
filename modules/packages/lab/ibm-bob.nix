{
  pkgs,
  lib,
  ...
}:
let
  pname = "ibm-bob";
  version = "1.121.0+bob2.0.0";

  src = pkgs.stdenv.mkDerivation {
    name = "${pname}-${version}.rpm";

    outputHashMode = "flat";
    outputHashAlgo = "sha256";
    outputHash = "sha256-cNhPLzAd43fl12zgkM1Vg6BimqgA/ZHXwImuWoY5WD4=";

    nativeBuildInputs = [
      pkgs.curl
      pkgs.cacert
      pkgs.gawk
    ];

    buildCommand = ''
      download_url="$(
        curl -fsS -D - -o /dev/null -X POST 'https://bob.ibm.com/api/download/bobide' \
          -F 'platform=linux' \
          -F 'version=${version}' \
          -F 'architecture=x64' \
          -F 'packageType=rpm' \
          | gawk 'BEGIN { IGNORECASE=1 } /^location: / { sub(/\r$/, "", $2); print $2 }'
      )"

      if [ -z "$download_url" ]; then
        echo "Failed to resolve IBM Bob download URL from API" >&2
        exit 1
      fi

      curl -fL "$download_url" -o "$out"
    '';
  };

  buildInputs = [
    pkgs.alsa-lib
    pkgs.at-spi2-atk
    pkgs.at-spi2-core
    pkgs.atk
    pkgs.cairo
    pkgs.cups
    pkgs.dbus
    pkgs.expat
    pkgs.glib
    pkgs.gtk3
    pkgs.libdrm
    pkgs.libgbm
    pkgs.libsecret
    pkgs.libsoup_3
    pkgs.libxkbcommon
    pkgs.libxkbfile
    pkgs.mesa
    pkgs.nspr
    pkgs.nss
    pkgs.pango
    pkgs.stdenv.cc.cc.lib
    pkgs.systemd
    pkgs.webkitgtk_4_1
    pkgs.libx11
    pkgs.libxcomposite
    pkgs.libxdamage
    pkgs.libxext
    pkgs.libxfixes
    pkgs.libxrandr
    pkgs.libxcb
    pkgs.libxcursor
    pkgs.libxi
    pkgs.libxtst
  ];

  ibmBob = pkgs.stdenv.mkDerivation {
    inherit
      pname
      version
      src
      buildInputs
      ;

    nativeBuildInputs = [
      pkgs.rpmextract
      pkgs.autoPatchelfHook
      pkgs.makeWrapper
    ];

    unpackPhase = ''
      rpmextract $src || true
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/bobide $out/share/applications $out/share/pixmaps

      if [ -d usr/share/bobide ]; then
        cp -r usr/share/bobide/* $out/share/bobide/
      fi

      if [ -d usr/share/applications ]; then
        cp -r usr/share/applications/* $out/share/applications/
      fi

      if [ -d usr/share/pixmaps ]; then
        cp -r usr/share/pixmaps/* $out/share/pixmaps/
      elif [ -d usr/share/icons ]; then
        cp -r usr/share/icons/* $out/share/icons/
      fi

      for f in $out/share/applications/*.desktop; do
        if [ -f "$f" ]; then
          substituteInPlace "$f" \
            --replace-warn "/usr/share/bobide/bobide" "$out/bin/bobide" \
            --replace-warn "/usr/bin/bobide" "$out/bin/bobide" \
            --replace-warn "Exec=bobide" "Exec=$out/bin/bobide" || true
        fi
      done

      makeWrapper $out/share/bobide/bobide $out/bin/bobide \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
        --add-flags "--no-sandbox"

      runHook postInstall
    '';

    meta = with lib; {
      description = "IBM Bob AI-powered Software Development Environment (IDE)";
      homepage = "https://bob.ibm.com";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
      mainProgram = "bobide";
    };
  };
in
{
  environment.systemPackages = [ ibmBob ];
}
