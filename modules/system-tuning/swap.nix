{ ... }:
{
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
