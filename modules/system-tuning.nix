{ pkgs, ... }:

{
  # OPTIMISE NIX
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 28d";
    };
  };

  # TRIM-SSD
  # services.fstrim = {
  #   enable = true;
  #   interval = "weekly";
  # };

  powerManagement.enable = true;
  services = {
    thermald.enable = true;
    preload.enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  services.scx.enable = true; # by default uses scx_rustland scheduler

  # SWAP and Z-RAM
  # swapDevices = [
  #   {
  #     device = "/swapfile";
  #     size = 16 * 1000; # 16GB
  #   }
  # ];

  zramSwap = {
    enable = true;
    # memoryPercent = 100; # hehe
  };
}
