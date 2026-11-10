{
  config,
  lib,
  ...
}:
{
  # Network configuration
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.modemmanager.enable = false; # Disable cellular modem daemon to save boot time and memory

  # Switch to native nftables backend
  networking.nftables.enable = true;

  networking.networkmanager = {
    enable = true;
    wifi = {
      backend = "iwd";
      powersave = false; # Prevent latency spikes and packet drops on Intel Wi-Fi
      scanRandMacAddress = true; # Randomize MAC during background Wi-Fi scanning
    };
  };

  # iwd MAC address randomization and wireless hardening
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        AddressRandomization = "network"; # Stable per-SSID randomized MAC
        AddressRandomizationRange = "full"; # Full 48-bit randomization (no Intel OUI leak)
      };
      Settings = {
        AutoConnect = true;
      };
      Network = {
        EnableIPv6 = true;
      };
    };
  };

  # Enable IPv4 forwarding for Waydroid and VM bridge routing
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
  };

  # Hardened NixOS Firewall Configuration
  networking.firewall = {
    enable = true;
    filterForward = true;

    # Removed virbr0 and waydroid0 from trustedInterfaces.
    # Guests are no longer granted unrestricted access to host ports; loopback remains trusted.
    trustedInterfaces = [ "lo" ];

    # Granular Ingress Control: Only allow DHCP (67) and DNS (53) from guest bridges
    interfaces."virbr0" = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [
        53
        67
      ];
    };
    interfaces."waydroid0" = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [
        53
        67
      ];
    };

    # LocalSend file transfer and discovery (restricted to host physical LAN)
    allowedTCPPorts = lib.mkIf (!config.my.packages.minimal) [ 53317 ];
    allowedUDPPorts = lib.mkIf (!config.my.packages.minimal) [ 53317 ];

    extraInputRules = ''
      # Drop all other ingress attempts from guest bridges to host ports (LocalSend 53317, dev servers, etc.)
      iifname { "virbr0", "waydroid0" } drop
    '';

    extraForwardRules = ''
      # Prevent guest VMs and Waydroid from probing host physical LAN (RFC1918) or cross-subnets
      iifname { "virbr0", "waydroid0" } ip daddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } drop
      iifname { "virbr0", "waydroid0" } ip6 daddr { fc00::/7, fe80::/10 } drop

      # Allow guest VMs and containers to forward out to public Internet (WAN)
      iifname { "virbr0", "waydroid0" } accept
    '';
  };
}
