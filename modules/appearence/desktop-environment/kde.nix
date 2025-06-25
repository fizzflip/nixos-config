{ pkgs, ... }:

{
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.karousel
    kdePackages.kcalc
    # kdePackages.kolourpaint
    kdePackages.partitionmanager
  ];

  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   konsole
  #   plasma-browser-integration
  # ];
}
