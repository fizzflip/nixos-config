{ pkgs, ... }:
{
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Network configuration
  networking = {
    # hostName = "artrey";

    # Disable systemd-resolved to avoid conflicts
    # We'll use our own DNS setup
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";

    # Enable networking
    networkmanager.enable = true;
    nameservers = [ "127.0.0.1" ];
  };

  # Disable systemd-resolved entirely to prevent conflicts
  services.resolved.enable = false;

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      53317
      3000 # AdGuard Home web interface
      53 # DNS (only if you want external access)
    ];
    allowedUDPPorts = [ 53317 ]; # Set AdGuard Home as the primary DNS resolver

  };

  # AdGuard Home for DNS encryption and system-level ad-blocking
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    openFirewall = false; # We'll manage firewall manually for security

    # Use the newer port option instead of settings.bind_port
    port = 3000;

    settings = {
      # Schema version - use the package's default schema version
      # schema_version = pkgs.adguardhome.schema_version;

      # Web interface binding - this is automatically handled by the port option
      # but we can still configure session timeout
      http = {
        address = "127.0.0.1:3000";
        session_ttl = 720;
      };

      # DNS server configuration
      dns = {
        bind_hosts = [ "127.0.0.1" ];
        port = 53;

        # Encrypted upstream DNS servers (DNS-over-HTTPS)
        upstream_dns = [
          "https://1.1.1.1/dns-query"
          "https://1.0.0.1/dns-query"
          "https://8.8.8.8/dns-query"
          "https://8.8.4.4/dns-query"
        ];

        # Bootstrap DNS for resolving DoH hostnames
        bootstrap_dns = [
          "1.1.1.1"
          "1.0.0.1"
          "8.8.8.8"
        ];

        # Security and performance settings
        enable_dnssec = true;
        cache_size = 4194304; # 4MB cache
        cache_ttl_min = 0;
        cache_ttl_max = 0;
        cache_optimistic = true;

        # Blocking configuration
        blocking_mode = "default";
        blocked_response_ttl = 10;

        # Disable EDNS Client Subnet for privacy
        edns_client_subnet = {
          custom_ip = "";
          enabled = false;
          use_custom = false;
        };
      };

      # Filtering configuration (equivalent to uBlock Origin)
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safebrowsing_enabled = true;
        safesearch_enabled = false;
      };

      # Disable DHCP server (we're only using DNS)
      dhcp = {
        enabled = false;
      };

      # Logging configuration
      log = {
        enabled = true;
        file = "";
        max_backups = 0;
        max_size = 100;
        max_age = 3;
        compress = false;
        local_time = false;
        verbose = false;
      };

      # Statistics
      stats = {
        enabled = true;
        interval = 24;
        ignored = [ ];
      };

      # Query logging
      querylog = {
        enabled = true;
        file_enabled = true;
        interval = 2160; # 90 days
        size_memory = 1000;
        ignored = [ ];
      };

      # Comprehensive filter lists (uBlock Origin equivalent)
      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
        {
          enabled = true;
          url = "https://easylist.to/easylist/easylist.txt";
          name = "EasyList";
          id = 2;
        }
        {
          enabled = true;
          url = "https://easylist.to/easylist/easyprivacy.txt";
          name = "EasyPrivacy";
          id = 3;
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt";
          name = "uBlock Origin filters";
          id = 4;
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt";
          name = "uBlock Origin - Privacy";
          id = 5;
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt";
          name = "uBlock Origin - Badware risks";
          id = 6;
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt";
          name = "uBlock Origin - Quick fixes";
          id = 7;
        }
        {
          enabled = true;
          url = "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=adblockplus&showintro=1&mimetype=plaintext";
          name = "Peter Lowe's Ad and tracking server list";
          id = 8;
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
          name = "Steven Black's Unified hosts file";
          id = 9;
        }
        {
          enabled = true;
          url = "https://someonewhocares.org/hosts/zero/hosts";
          name = "Dan Pollock's hosts file";
          id = 10;
        }
      ];

      # # Custom filtering rules (add your own rules here)
      # user_rules = [
      #   # Example custom rules:
      #   # "||example-ads.com^"
      #   # "@@||example-whitelist.com^"
      # ];
    };
  };

  # Install useful DNS and network troubleshooting tools
  environment.systemPackages = with pkgs; [
    dig
    dnslookup
    curl
    wget
    dnsutils
    traceroute
    netcat-gnu
  ];

  # Optional: Automated filter list updates
  systemd.services.adguard-update-filters = {
    description = "Update AdGuard Home filter lists";
    serviceConfig = {
      Type = "oneshot";
      User = "adguardhome"; # Use the adguardhome user, not root
      ExecStart = "${pkgs.curl}/bin/curl -s -f -X POST http://127.0.0.1:3000/control/filtering/refresh";
      # Add authentication if needed (uncomment and configure)
      # ExecStart = "${pkgs.curl}/bin/curl -s -f -u admin:password -X POST http://127.0.0.1:3000/control/filtering/refresh";
    };
    # Only run if AdGuard Home is running
    wants = [ "adguardhome.service" ];
    after = [ "adguardhome.service" ];
  };

  systemd.timers.adguard-update-filters = {
    description = "Update AdGuard Home filter lists daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "2h"; # Random delay to avoid server load spikes
    };
  };

  # networking = {
  #   dns-crypt.enable = true;
  # };

  # services.ntopng = {
  #   enable = true;
  # };

  # services.adguardhome = {
  #   enable = true;
  #   listenAddress = "0.0.0.0"; # or restrict to localhost/VPN
  #   dnsPort = 53;
  #   upstreams = [ "https://dns.adguard.com/dns-query" ];
  #   blocklists = [
  #     "https://easylist.to/easylist/easylist.txt"
  #     "https://easylist.to/easylist/easyprivacy.txt"
  #   ];
  # };
}

# 00
# {
#   imports = [
#     ./hardware-configuration.nix
#   ];

#   # System configuration
#   system.stateVersion = "24.05";

#   # Enable flakes
#   nix.settings.experimental-features = [ "nix-command" "flakes" ];

#   # Network configuration
#   networking = {
#     hostName = "your-hostname";

#     # Enable NetworkManager but disable its DNS management
#     networkmanager = {
#       enable = true;
#       dns = "none";
#     };

#     # Disable dhcpcd DNS management
#     dhcpcd.extraConfig = "nohook resolv.conf";

#     # Set AdGuard Home as the primary DNS resolver
#     nameservers = [ "127.0.0.1" ];
#   };

#   # Disable systemd-resolved entirely to prevent conflicts
#   services.resolved.enable = false;

#   # Firewall configuration - manually manage for better security
#   networking.firewall = {
#     enable = true;
#     allowedTCPPorts = [
#       3000  # AdGuard Home web interface (localhost only)
#     ];
#     # Note: Port 53 is not opened externally for security
#     # AdGuard Home only serves DNS on localhost
#   };

# Ensure DNS resolution works during boot with fallback
# Only override resolv.conf if not using NetworkManager's DNS management
# environment.etc."resolv.conf" = lib.mkIf (!config.networking.networkmanager.enable || config.networking.networkmanager.dns == "none") {
#   text = ''
#     # AdGuard Home DNS
#     nameserver 127.0.0.1
#     # Fallback DNS in case AdGuard Home is not running
#     nameserver 1.1.1.1
#     nameserver 1.0.0.1
#   '';
#   mode = "0644";
# };

# Optional: Enable systemd-networkd for more advanced network management
# Uncomment if you prefer networkd over NetworkManager
# systemd.network.enable = true;
# networking.useNetworkd = true;
# networking.networkmanager.enable = false;
# }
