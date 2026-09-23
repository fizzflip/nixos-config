{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.my.services.printing.enable {
  # Enable CUPS
  services.printing.enable = true;

  # Enable HP drivers (includes the proprietary plugin)
  services.printing.drivers = [ pkgs.hplipWithPlugin ];

  # Enable Avahi for network printer discovery (crucial for Wi-Fi printers)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
