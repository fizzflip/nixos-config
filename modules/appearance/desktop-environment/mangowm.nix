{ inputs, pkgs, ... }:

{
  imports = [
    inputs.mangowm.nixosModules.mango
    ../components/dms.nix
    ../components/sddm.nix
    ../components/nautilus.nix
    ../components/noctalia.nix
  ];

  programs.mango.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  security = {
    polkit.enable = true;
  };

  systemd.user.services.polkit-agent = {
    description = "Polkit authentication agent";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      Type = "simple";
    };
  };

  services = {
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = [
    pkgs.foot
    pkgs.rofi
    pkgs.polkit_gnome
    pkgs.xwayland-satellite
    pkgs.gnome-disk-utility
    pkgs.orchis-theme
    pkgs.phinger-cursors
    pkgs.wallust
    pkgs.nomacs
    pkgs.wl-clipboard-rs
  ];
}
