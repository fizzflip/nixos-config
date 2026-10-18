{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.packages.artcraft;

  # Parameterized builder for Storytold ArtCraft applications
  mkArtcraftApp =
    {
      pname,
      version,
      hash,
      description,
      desktopName,
    }:
    let
      tarballSource = pkgs.fetchurl {
        url = "https://github.com/storytold/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.tar.gz";
        inherit hash;
      };
      skipVar = "${lib.toUpper (lib.replaceStrings [ "-" ] [ "_" ] pname)}_SKIP_LIB_CHECK";
      runtimeLibs = [
        pkgs.stdenv.cc.cc.lib
        pkgs.alsa-lib
        pkgs.dbus
        pkgs.libGL
        pkgs.vulkan-loader
        pkgs.wayland
        pkgs.libxkbcommon
        pkgs.libx11
        pkgs.libxcb
        pkgs.libxcursor
        pkgs.libxi
        pkgs.libxrandr
      ];
    in
    pkgs.stdenv.mkDerivation {
      inherit pname version;
      src = tarballSource;

      nativeBuildInputs = [
        pkgs.autoPatchelfHook
        pkgs.makeWrapper
      ];

      buildInputs = [
        pkgs.stdenv.cc.cc.lib
        pkgs.alsa-lib
      ];

      # AutoPatchelf runtime dependencies (added to DT_RUNPATH)
      runtimeDependencies = runtimeLibs;

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"

        # The upstream tarball unpacks bin/ and share/
        cp -r bin share "$out"/

        # Provide standard alias desktop file for launchers
        if [ -f "$out/share/applications/ai.storyteller.${pname}.desktop" ] && [ ! -f "$out/share/applications/${pname}.desktop" ]; then
          ln -s "ai.storyteller.${pname}.desktop" "$out/share/applications/${pname}.desktop"
        fi

        runHook postInstall
      '';

      postFixup = ''
        for bin in "$out"/bin/*; do
          [ -f "$bin" ] && [ -x "$bin" ] || continue
          wrapProgram "$bin" \
            --set-default "${skipVar}" "1" \
            --set-default WINIT_UNIX_BACKEND "wayland" \
            --set-default WGPU_BACKEND "vulkan" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}:/run/opengl-driver/lib"
        done
      '';

      meta = {
        description = "${desktopName}: ${description} (ArtCraft suite)";
        homepage = "https://github.com/storytold/${pname}";
        license = [
          lib.licenses.asl20
          lib.licenses.mit
        ];
        mainProgram = pname;
        platforms = [ "x86_64-linux" ];
      };
    };

  pdfcraft = mkArtcraftApp {
    pname = "pdfcraft";
    version = "0.9.0";
    hash = "sha256-/199o2oQiTQOP9umlrKGzDF6yPBwXMjETBxJ2cpMVOA=";
    description = "Read, organize, combine, split, annotate and secure PDFs";
    desktopName = "PdfCraft";
  };

  wordcraft = mkArtcraftApp {
    pname = "wordcraft";
    version = "0.8.0";
    hash = "sha256-Ds4Hzz2RuSPf2A+QMQ4EmDveZvAnnGtg3c6JWW3eDd8=";
    description = "Clean-room open-source word processor";
    desktopName = "WordCraft";
  };

  vectorcraft = mkArtcraftApp {
    pname = "vectorcraft";
    version = "0.13.1";
    hash = "sha256-NcD89tP56/9vM9JX/3Du9BQpbzfw2B8oTm+XDiD9ssg=";
    description = "Clean-room open-source vector design & illustration editor";
    desktopName = "VectorCraft";
  };

  photocraft = mkArtcraftApp {
    pname = "photocraft";
    version = "0.10.0";
    hash = "sha256-xdRVeF2cLq9pW/jmMnxNbSOjnduVamEU8MW2Qyb5hOE=";
    description = "Clean-room open-source non-destructive RAW photo editor";
    desktopName = "PhotoCraft";
  };

  selectedPackages =
    (lib.optional cfg.pdfcraft pdfcraft)
    ++ (lib.optional cfg.wordcraft wordcraft)
    ++ (lib.optional cfg.vectorcraft vectorcraft)
    ++ (lib.optional cfg.photocraft photocraft);
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = selectedPackages;

    xdg.mime.defaultApplications = lib.mkIf cfg.setDefaultMimeTypes (
      lib.mkMerge [
        (lib.mkIf cfg.pdfcraft {
          "application/pdf" = [
            "ai.storyteller.pdfcraft.desktop"
            "pdfcraft.desktop"
          ];
          "application/x-pdf" = [
            "ai.storyteller.pdfcraft.desktop"
            "pdfcraft.desktop"
          ];
          "application/vnd.pdf" = [
            "ai.storyteller.pdfcraft.desktop"
            "pdfcraft.desktop"
          ];
        })
        (lib.mkIf cfg.wordcraft {
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [
            "ai.storyteller.wordcraft.desktop"
            "wordcraft.desktop"
          ];
          "application/msword" = [
            "ai.storyteller.wordcraft.desktop"
            "wordcraft.desktop"
          ];
          "application/vnd.oasis.opendocument.text" = [
            "ai.storyteller.wordcraft.desktop"
            "wordcraft.desktop"
          ];
          "application/rtf" = [
            "ai.storyteller.wordcraft.desktop"
            "wordcraft.desktop"
          ];
        })
        (lib.mkIf cfg.vectorcraft {
          "image/svg+xml" = [
            "ai.storyteller.vectorcraft.desktop"
            "vectorcraft.desktop"
          ];
          "image/svg+xml-compressed" = [
            "ai.storyteller.vectorcraft.desktop"
            "vectorcraft.desktop"
          ];
          "application/illustrator" = [
            "ai.storyteller.vectorcraft.desktop"
            "vectorcraft.desktop"
          ];
        })
      ]
    );
  };
}
