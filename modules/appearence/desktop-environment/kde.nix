{ pkgs, ... }:

{
  environment.systemPackages = [
    # (pkgs.catppuccin-sddm.override {
    #   flavor = "mocha";
    #   font = "Noto Sans";
    #   fontSize = "9";
    #   # background = "${./wallpaper.png}";
    #   loginBackground = true;
    # })

    (pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; })

    pkgs.kdePackages.qtmultimedia
    pkgs.kdePackages.karousel
    pkgs.kdePackages.kcalc
    pkgs.kdePackages.kolourpaint
    pkgs.kdePackages.partitionmanager
    pkgs.python312Packages.kde-material-you-colors
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
  };

  services.desktopManager.plasma6.enable = true;
  # environment.plasma6.excludePackages = with pkgs.kdePackages; [ konsole plasma-browser-integration ];
}
