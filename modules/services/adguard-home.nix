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

          # # BebasDNS by BebasID
          "https://dns.bebasid.com/unfiltered"
          "tls://unfiltered.dns.bebasid.com:853"

          # # CFIEC Public DNS
          "tls://dns.cfiec.net"
          "https://dns.cfiec.net/dns-query"

          # # Cisco OpenDNS
          "tls://dns.opendns.com"
          "https://doh.opendns.com/dns-query"
          "2.dnscrypt-cert.opendns.com"

          # # ControlD
          "https://freedns.controld.com/p0"
          "p0.freedns.controld.com"

          # # ASASAS
          "tls://unicast.censurfridns.dk"
          "tls://anycast.censurfridns.dk"
          "tls://dns.cmrg.net"

          "sdns://AgcAAAAAAAAADTIxNy4xNjkuMjAuMjMADWRucy5hYS5uZXQudWsKL2Rucy1xdWVyeQ"
          "sdns://AgcAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tCy91bmNlbnNvcmVk"
          "sdns://AQcAAAAAAAAADTc4LjEyOS4yNDguNjcgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz"
          "sdns://AQcAAAAAAAAADDE0Ni43MC4zMS40MyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM"
          "sdns://AQcAAAAAAAAADTE0Ni43MC4xNTQuNjcgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz"

          "sdns://AQcAAAAAAAAADzE2NS4yMzEuMjUzLjE2MyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM" # cs-india
        ];
        anonymize_client_ip = true;
        upstream_mode = "parallel";
        port = 53;
      };
    };
  };
  networking.nameservers = [ "127.0.0.1" ];
}
