{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.sunshine;
in
{
  options.my.services.sunshine = {
    enable = lib.mkEnableOption "Sunshine self-hosted game & desktop streaming server for Moonlight";
  };

  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      openFirewall = true;
      capSysAdmin = true;
    };
  };
}
