{ ... }:
{
  imports = [
    ./kernel.nix
    ./network.nix
  ];

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
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/" ];
    interval = "monthly";
  };

  hardware.block.defaultSchedulerRotational = "bfq";

  powerManagement.enable = true;
  services.thermald.enable = true;

  services.scx.enable = true;

  # SWAP and Z-RAM
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1000; # 16GB
    }
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    priority = 100;
  };
}
