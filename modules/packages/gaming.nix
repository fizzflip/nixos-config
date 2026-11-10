{
  inputs,
  config,
  pkgs,
  lib,
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
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = false;
        dedicatedServer.openFirewall = false;
        localNetworkGameTransfers.openFirewall = false;
        package = inputs.millennium.packages."${pkgs.stdenv.hostPlatform.system}".millennium-steam;
      };
      gamemode.enable = true;
      gamescope.enable = true;
    };

    hardware.steam-hardware.enable = true;

    environment.systemPackages = [
      pkgs.mangohud
      pkgs.protonup-qt
    ];
  };
}
