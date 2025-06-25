{ pkgs, ... }:
{

  imports = [
    ./waybar.nix
  ];

  programs.niri.enable = true;

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  security = {
    polkit.enable = true;
    soteria.enable = true;
  };
  # systemd.user.services.soteria = {
  #   enable = true;
  #   description = "Soteria Polkit Agent";
  #   wantedBy = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.soteria}/bin/soteria";
  #   };
  # };
  services = {
    # Auto-mounting stuff
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = with pkgs; [
    fuzzel
    mako
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    alacritty
    swayidle
    swaylock
    xwayland-satellite

    material-icons
    material-design-icons

    cava
    mpris-timer
    kdePackages.dolphin
  ];

}
