{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.nextdns;
in
{
  options.my.services.nextdns = {
    enable = lib.mkEnableOption "NextDNS encrypted DNS proxy";
  };

  config = lib.mkIf cfg.enable {
    services.nextdns = {
      enable = true;
      arguments = [
        "-config-file"
        "/var/secrets/nextdns.conf"
        "-cache-size"
        "10MB" # Enables local caching
        "-bogus-priv" # Stops leaking local lookups
      ];
    };

    # Tell the system to use the local NextDNS daemon
    networking.nameservers = [ "127.0.0.1" ];

    # Stop NetworkManager or DHCP from overriding your 127.0.0.1 setting
    networking.networkmanager.dns = "none";
  };
}
