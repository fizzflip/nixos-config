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
