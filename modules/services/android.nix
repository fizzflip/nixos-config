{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.services.android;
in
{
  options.my.services.android = {
    enable = lib.mkEnableOption "Waydroid and Android development environment";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };

    environment.systemPackages = [
      pkgs.android-tools
      pkgs.android-studio
      pkgs.waydroid-helper
    ];
  };
}
