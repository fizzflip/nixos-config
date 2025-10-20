{ ... }:
{
  services.adguardhome = {
    enable = true;
    port = 3000;
    allowDHCP = true;
    settings = {
      web_port = 3000;
      web_address = "0.0.0.0";
      dns = {
        bind_hosts = [
          "127.0.0.1"
          "::1"
        ];
        upstream_dns = [
          "https://dns.nextdns.io"
          "https://dns.quad9.net/dns-query"
          "https://dns.mullvad.net/dns-query"
          "https://dns.cloudflare.com/dns-query"
          "https://cloudflare-dns.com/dns-query"
          "https://dns.adguard-dns.com/dns-query"
          "https://base.dns.mullvad.net/dns-query"
        ];
        anonymize_client_ip = true;
        upstream_mode = "parallel";
        port = 53;
      };
    };
  };
  networking.nameservers = [ "127.0.0.1" ];
}
