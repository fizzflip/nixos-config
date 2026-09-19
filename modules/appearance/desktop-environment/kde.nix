{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../components/sddm.nix
    ../../services/bluetooth.nix
  ];

  config = lib.mkIf (config.my.desktop.environment == "kde") {
    services.desktopManager.plasma6.enable = true;
    services.speechd.enable = lib.mkForce false;
    environment.plasma6.excludePackages = [ pkgs.kdePackages.plasma-browser-integration ];

    environment.systemPackages = [
      pkgs.kdePackages.kcalc
      pkgs.kdePackages.partitionmanager
    ];
  };
}
