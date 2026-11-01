{
  config,
  inputs,
  ...
}:
{
  nix = {
    # Isolate compilation threads to background scheduling to prevent GUI starvation
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "best-effort";
    daemonIOSchedPriority = 7;

    # Background weekly batch deduplication to avoid inline build/rebuild latency
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

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

      # Store optimization & pure flake registry policy
      auto-optimise-store = false;
      flake-registry = ""; # Prevents fetching global flake-registry.json over the network
      keep-outputs = false;
      keep-derivations = false;

      # Concurrency tuning for 2 physical cores / 4 threads and 8GB RAM
      # Serializes package derivations to prevent RAM explosion while compiling with all 4 threads
      max-jobs = 1;
      cores = 4;

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

    # Pin nixpkgs registry to active flake input to make `nix run/shell nixpkgs#...` instant
    registry.nixpkgs.flake = inputs.nixpkgs;

    # Pure flake setup without legacy channel state drift
    channel.enable = false;
  };

  # Cage nix-daemon into background slice with memory ceilings to protect desktop responsiveness
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp/nix-daemon";
    serviceConfig = {
      Slice = "background.slice";
      Nice = 19;
      MemoryHigh = "5500M";
      MemoryMax = "7000M";
    };
  };

  # Automatic creation and aging of the build scratch directory in /var/tmp
  systemd.tmpfiles.rules = [
    "d /var/tmp/nix-daemon 1777 root root 2d"
  ];
}
