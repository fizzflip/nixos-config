{ pkgs, ... }:

{
  imports = [
    ../components/sddm.nix
    ../../services/bluetooth.nix
  ];

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = [ pkgs.kdePackages.plasma-browser-integration ];

  environment.systemPackages = [
    pkgs.kdePackages.kcalc
    pkgs.kdePackages.partitionmanager
    pkgs.python312Packages.kde-material-you-colors
  ];

  services.fwupd.enable = true;
}
