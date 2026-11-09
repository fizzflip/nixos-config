{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.avahi;
in
{
  options.my.services.avahi = {
    enable = lib.mkEnableOption "Avahi mDNS/DNS-SD daemon for zero-configuration .local network discovery";
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      settings.publish = {
        "disable-publishing" = false;
        "publish-addresses" = true;
      };
    };
  };
}
