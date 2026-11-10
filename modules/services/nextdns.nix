{
  config,
  lib,
  pkgs,
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

    # Delay NextDNS startup until the USB tether (Pixel 8 / enp0s20f0u1) is online.
    # NextDNS DoH endpoints are only reachable via the cellular tether; starting before
    # the device appears causes ~30s of "network is unreachable" SERVFAIL storms at boot.
    # Using After+Wants (not BindsTo) so NextDNS keeps running if the tether is unplugged.
    # Restart=on-failure lets systemd revive NextDNS once the tether re-appears.
    systemd.services.nextdns = {
      after = [
        "sys-subsystem-net-devices-enp0s20f0u1.device"
        "network-online.target"
      ];
      wants = [
        "sys-subsystem-net-devices-enp0s20f0u1.device"
        "network-online.target"
      ];
      serviceConfig = {
        Restart = lib.mkForce "on-failure";
        RestartSec = lib.mkForce "5s";
      };
    };

    # NetworkManager-wait-online was masked; re-enable it so network-online.target
    # actually waits for NM to report full connectivity before nextdns.service starts.
    # nm-online -s checks for a connected/activated connection with a default route.
    # --timeout=60 provides a graceful degradation window on tether-less boots.
    systemd.services.NetworkManager-wait-online = {
      enable = lib.mkForce true;
      wantedBy = [ "network-online.target" ];
      before = [ "network-online.target" ];
      serviceConfig = {
        ExecStart = lib.mkForce [
          ""
          "${pkgs.networkmanager}/bin/nm-online -s -q --timeout=60"
        ];
        Restart = "no";
      };
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
