{ config, ... }: {
  nix = {
    # Isolate compilation threads to background scheduling to prevent GUI starvation
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        config.my.user.name
      ];
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://attic.xuyh0120.win/lantian?priority=41"
        "https://cache.xinux.uz?priority=50"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
      ];

      # Use all hardware threads on the 2-core / 4-thread CPU
      max-jobs = "auto";
      cores = 0;

      # Optimize binary cache network downloads safely for memory-constrained hardware
      download-buffer-size = 33554432; # 32 MiB buffer for high-bandwidth chunk downloads
      http-connections = 25; # Balanced parallel HTTP connection pool
      connect-timeout = 5; # Fast failure on unreachable mirrors
      stalled-download-timeout = 10;
      builders-use-substitutes = true;

      # Machine capabilities for package selection
      system-features = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
    };
  };
}
