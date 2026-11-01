{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.my.desktop.environment == "gnome") {
    services = {
      displayManager.gdm = {
        enable = true;
      };
      desktopManager.gnome.enable = true;
      gvfs.enable = true;
    };

    # Excluded default GNOME components
    environment.gnome.excludePackages = [
      pkgs.geary
      pkgs.totem
      pkgs.baobab
      pkgs.yelp
      pkgs.snapshot
      pkgs.gnome-clocks
      pkgs.gnome-contacts
      pkgs.gnome-weather
      pkgs.gnome-logs
      pkgs.gnome-characters
      pkgs.gnome-music
      pkgs.gnome-tour
      pkgs.gnome-maps
    ];

    # GNOME Extensions & Management Tools
    environment.systemPackages = [
      pkgs.gnomeExtensions.blur-my-shell
      pkgs.gnomeExtensions.dash-to-dock
      pkgs.gnomeExtensions.user-themes
      pkgs.flat-remix-icon-theme
      pkgs.papirus-icon-theme
      pkgs.gnomeExtensions.launch-new-instance
      pkgs.gnomeExtensions.soft-brightness-plus
      pkgs.gnomeExtensions.appindicator
      pkgs.gnome-settings-daemon
      pkgs.gnome-tweaks
      pkgs.gnomeExtensions.clipboard-indicator
      pkgs.gnomeExtensions.day-progress
      pkgs.gnomeExtensions.just-perfection
      pkgs.gnomeExtensions.open-bar
    ];
  };
}
