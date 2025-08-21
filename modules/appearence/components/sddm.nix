{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.kdePackages.qtmultimedia
   (pkgs.sddm-astronaut.override {
      embeddedTheme = "pixel_sakura";
   })
  ];

  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    package = pkgs.kdePackages.sddm;
    extraPackages = [
      pkgs.sddm-astronaut
      pkgs.kdePackages.qtbase
      pkgs.kdePackages.qtwayland
      pkgs.kdePackages.qtmultimedia
    ];
  };
}