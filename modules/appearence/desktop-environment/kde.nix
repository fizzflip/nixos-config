{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.kdePackages.kcalc
    pkgs.kdePackages.partitionmanager

    pkgs.python312Packages.kde-material-you-colors

    pkgs.kdePackages.qtmultimedia
    (pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; })
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
  };

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ plasma-browser-integration ];
}
