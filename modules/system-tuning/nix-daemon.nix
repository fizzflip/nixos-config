{ ... }: {
  nix = {
    # Isolate compilation threads to background scheduling to prevent GUI starvation
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;

    settings = {
      # Use all hardware threads on the 2-core / 4-thread CPU
      max-jobs = "auto";
      cores = 0;

      # Optimize binary cache network downloads
      download-buffer-size = 134217728; # 128 MiB buffer for high-bandwidth chunk downloads
      http-connections = 50; # Parallel HTTP connection pool
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
