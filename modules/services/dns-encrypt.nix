{...}:
{
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      # Optional: Enable query logging
      # query_log.file = "/var/log/dnscrypt-proxy/query.log";

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # Optional: Specify preferred DNS servers
      # server_names = [ "cloudflare" "quad9-dnscrypt-ip4-filter-pri" ];
    };
  };

  networking = {
    nameservers = [ "127.0.0.1" "::1" ];
    # Prevent DHCP from overwriting resolv.conf
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager
    networkmanager.dns = "none";
  };

  # Ensure systemd-resolved is disabled to avoid conflicts
  services.resolved.enable = false;
}
