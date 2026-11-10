{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.bluetooth;
in
{
  options.my.services.bluetooth = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Bluetooth service with experimental features (battery percentage reporting).";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      settings.General.Experimental = true; # shows battery % and extra BT info
    };
  };
}
