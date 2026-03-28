{ ... }:
{
  services.nextdns = {
    enable = true;
    arguments = [
      "-config-file"
      "/var/secrets/nextdns.conf"
      "-cache-size"
      "10MB" # Enables local caching
      "-auto-activate" # Finds the lowest latency server
      "-bogus-priv" # Stops leaking local lookups
    ];
  };

  # Tell the system to use the local NextDNS daemon
  networking.nameservers = [ "127.0.0.1" ];

  # CRITICAL: Stop NetworkManager or DHCP from overriding your 127.0.0.1 setting
  networking.networkmanager.dns = "none";
  # If you don't use NetworkManager and use standard dhcpcd instead, use this:
  # networking.dhcpcd.extraConfig = "nohook resolv.conf";
}
