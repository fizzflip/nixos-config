{ ... }:
{
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1000; # 16GB
    }
  ];

  # Disable ZRAM so they don't fight
  zramSwap.enable = false;

  # Explicitly enforce ZSWAP parameters just in case
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.shrinker_enabled=1"
  ];
}
