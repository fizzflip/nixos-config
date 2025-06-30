{ ... }:

{
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Disable the firewall
  # networking.firewall.enable = false;

  # Network configuration
  networking.networkmanager.enable = true;

  # Open ports in the firewall
  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

  networking.dns-crypt.enable = true;

  # services.adguardhome = {
  #   enable = true;
  #   host = "0.0.0.0";
  #   port = 3000;
  # };
  # networking.nameservers = [ "127.0.0.1" ];

  # services.ntopng = {
  #   enable = true;
  # };
}
