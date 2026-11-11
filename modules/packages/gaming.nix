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
    enable = lib.mkEnableOption "Gaming software stack (Kryoto Desktop launcher, GameMode, Gamescope, MangoHud)";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gamemode.enable = true;
      gamescope.enable = true;
    };

    environment.systemPackages = [
      inputs.packaging-nixos-apps.packages.${pkgs.stdenv.hostPlatform.system}.kryoto-desktop
      pkgs.mangohud
    ];
  };
}
