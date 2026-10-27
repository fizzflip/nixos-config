{ pkgs, ... }:
{
  programs = {
    dconf.enable = true;
    gdk-pixbuf.modulePackages = [
      pkgs.librsvg
      pkgs.webp-pixbuf-loader
    ];
  };

  environment.pathsToLink = [
    "/share/gsettings-schemas"
    "/share/thumbnailers"
  ];

  environment.systemPackages = [
    pkgs.hicolor-icon-theme
    pkgs.adwaita-icon-theme
    pkgs.gsettings-desktop-schemas
  ];
}
