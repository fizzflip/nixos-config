{ pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = [ pkgs.kdePackages.plasma-browser-integration ];

  environment.systemPackages = [
    pkgs.kdePackages.kcalc
    pkgs.kdePackages.partitionmanager

    pkgs.kdePackages.akregator

    pkgs.python312Packages.kde-material-you-colors

    pkgs.kdePackages.qtmultimedia
    (pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; })
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
  };

  services.fwupd.enable = true;
}
