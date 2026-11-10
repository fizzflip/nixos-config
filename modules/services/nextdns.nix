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
        "20MB" # Expanded local caching
        "-cache-max-age"
        "24h" # Retain cache across long sessions
        "-max-inflight-requests"
        "512" # Scale proxy capacity for parallel browser tabs
        "-max-inflight-upstream-requests"
        "128" # Prevent upstream queue starvation drops
        "-detect-captive-portals" # Graceful captive portal detection
        "-bogus-priv" # Stops leaking local lookups
        "-setup-router=false" # Client machine setup
      ];
    };

    # Tell the system to use the local NextDNS daemon with public fallbacks
    networking.nameservers = [
      "127.0.0.1"
      "1.1.1.1"
      "9.9.9.9"
    ];

    # Stop NetworkManager or DHCP from overriding your 127.0.0.1 setting
    networking.networkmanager.dns = "none";
  };
}
