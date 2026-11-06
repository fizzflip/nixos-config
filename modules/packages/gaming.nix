{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.packages.gaming;
in
{
  options.my.packages.gaming = {
    enable = lib.mkEnableOption "Steam and gaming software stack (GameMode, Gamescope, MangoHud, Steam Hardware udev rules)";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      localNetworkGameTransfers.openFirewall = false;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
    hardware.steam-hardware.enable = true;

    environment.systemPackages = [
      pkgs.mangohud
      pkgs.protonup-qt
    ];
  };
}
