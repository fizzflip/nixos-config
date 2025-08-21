{ pkgs, ... }:

{
  services.xserver = {
    # Enable the X11 windowing system.
    # enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager = {
      gdm.enable = true;
      gdm.wayland = true;
    };
    desktopManager.gnome.enable = true;

    xkb = {
      layout = "us";
      variant = "";
    };

    excludePackages = [ pkgs.xterm ];
  };

  # services.gnome.core-utilities.enable = false;

  # Excluded GNOME components
  environment.gnome.excludePackages = [
    pkgs.geary # email reader
    pkgs.totem # video player
    pkgs.baobab # disk usage analyzer
    pkgs.yelp # help
    # seahorse # password manager
    pkgs.snapshot # webcam viewer

    pkgs.gnome-clocks
    pkgs.gnome-contacts
    pkgs.gnome-weather
    pkgs.gnome-logs
    pkgs.gnome-characters
    pkgs.gnome-music
    pkgs.gnome-tour
    pkgs.gnome-maps
  ];

  # GNOME Extensions/Themes/Stuff
  environment.systemPackages = [

    # Blur goes brrr
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.dash-to-dock
    # gnomeExtensions.dynamic-panel

    # WMs on top of GNOME
    # gnomeExtensions.forge
    # gnomeExtensions.tiling-shell
    pkgs.gnomeExtensions.paperwm

    # Theme
    pkgs.gnomeExtensions.user-themes
    # marble-shell-theme
    # flat-remix-gnome
    pkgs.orchis-theme
    pkgs.whitesur-gtk-theme
    pkgs.whitesur-cursors
    pkgs.whitesur-icon-theme

    # Icon-packs
    pkgs.flat-remix-icon-theme
    pkgs.papirus-icon-theme

    # QoL
    pkgs.gnomeExtensions.launch-new-instance
    pkgs.gnomeExtensions.soft-brightness-plus
    pkgs.gnomeExtensions.appindicator

    # gnomeExtensions.astra-monitor
    # lspci
    # nethogs
    # iotop
    # gtop

    pkgs.gnome-settings-daemon
    pkgs.gnome-tweaks

    pkgs.gnomeExtensions.clipboard-indicator
    pkgs.gnomeExtensions.day-progress
    pkgs.gnomeExtensions.just-perfection
    pkgs.gnomeExtensions.open-bar
    # gnomeExtensions.media-controls
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
