{ config, lib, ... }: {
  networking.hostName = lib.mkDefault "machine"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Disable the firewall
  # networking.firewall.enable = false;

  # Network configuration
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.networkmanager = {
    enable = true;
    wifi = {
      backend = "iwd";
      powersave = true;
      macAddress = "stable";
    };
  };

  # Open ports in the firewall
  networking.firewall = {
    enable = true;
    # Port 53317: LocalSend file transfer and discovery (opened only when full package suite is installed)
    allowedTCPPorts = lib.mkIf (!config.my.packages.minimal) [ 53317 ];
    allowedUDPPorts = lib.mkIf (!config.my.packages.minimal) [ 53317 ];
  };
}
