{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf (config.my.desktop.environment != "none") {
  programs = {
    dconf.enable = true;
    gdk-pixbuf.modulePackages = [
      pkgs.librsvg
      pkgs.webp-pixbuf-loader
    ];
  };

  environment = {
    pathsToLink = [
      "/share/gsettings-schemas"
      "/share/glib-2.0/schemas"
      "/share/thumbnailers"
    ];

    systemPackages = [
      pkgs.glib.dev
      pkgs.hicolor-icon-theme
      pkgs.adwaita-icon-theme
      pkgs.gsettings-desktop-schemas
    ];

    extraSetup = ''
      if [ -d "$out/share/gsettings-schemas" ]; then
        mkdir -p "$out/share/glib-2.0/schemas"
        for d in "$out/share/gsettings-schemas"/*; do
          if [ -d "$d/glib-2.0/schemas" ]; then
            ln -sf "$d/glib-2.0/schemas"/*.xml "$out/share/glib-2.0/schemas/" 2>/dev/null || true
            ln -sf "$d/glib-2.0/schemas"/*.override "$out/share/glib-2.0/schemas/" 2>/dev/null || true
          fi
        done
        if [ -x "${pkgs.buildPackages.glib.dev}/bin/glib-compile-schemas" ]; then
          "${pkgs.buildPackages.glib.dev}/bin/glib-compile-schemas" "$out/share/glib-2.0/schemas"
        fi
      fi
    '';
  };
}
