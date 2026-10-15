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
        "auto-allocate-uids"
        "cgroups"
      ];
      trusted-users = [
        "root"
        config.my.user.name
      ];
      substituters = [
        "https://cache.nixos.org?priority=10"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      # Use all hardware threads on the 2-core / 4-thread CPU
      max-jobs = "auto";
      cores = 0;

      # Optimize binary cache network downloads safely for memory-constrained hardware
      download-buffer-size = 33554432; # 32 MiB buffer for high-bandwidth chunk downloads
      tarball-ttl = 604800; # 7 days
      warn-dirty = false;
      auto-allocate-uids = true;
      use-cgroups = true;
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

  # Cage nix-daemon into the low-weight CPU/IO slice to prevent interactive desktop stutter
  systemd.services.nix-daemon.serviceConfig.Slice = "background.slice";
}
