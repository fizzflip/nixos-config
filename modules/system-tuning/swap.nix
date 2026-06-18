{ ... }: {
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # Uses zstd for optimal compression/speed
    memoryPercent = 100; # Maps zram 1:1 with physical RAM
  };
  boot = {
    kernelParams = [ "zswap.enabled=0" ];
    kernel.sysctl = {
      "vm.swappiness" = 150; # Aggressively push data to zram
      "vm.watermark_boost_factor" = 0; # Prevents latency spikes during memory fragmentation
      "vm.watermark_scale_factor" = 125; # Keeps the kernel from stressing out when RAM gets low
      "vm.page-cluster" = 0; # Crucial: Disables swap read-ahead
    };
  };
}
