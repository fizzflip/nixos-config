{ ... }: {
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # Uses zstd for optimal compression/speed
    memoryPercent = 100; # Maps zram 1:1 with physical RAM (8GB virtual swap) backed by zstd compression
    priority = 100; # Ensure ZRAM always takes highest priority over any disk swap
  };
  boot = {
    kernelParams = [ "zswap.enabled=0" ];
    kernel.sysctl = {
      "vm.swappiness" = 180; # Aggressively push cold anonymous pages to zram before evicting cache
      "vm.watermark_boost_factor" = 0; # Prevents latency spikes during memory fragmentation
      "vm.watermark_scale_factor" = 125; # Keeps the kernel from stressing out when RAM gets low
      "vm.page-cluster" = 0; # Crucial: Disables swap read-ahead
      "vm.vfs_cache_pressure" = 50; # Retain directory/inode metadata in RAM longer
      "vm.dirty_bytes" = 268435456; # 256 MiB maximum unwritten pages
      "vm.dirty_background_bytes" = 67108864; # 64 MiB background writeback trigger
      "vm.stat_interval" = 10; # Reduce VM stat timer interrupts (10s interval)
    };
  };
}
