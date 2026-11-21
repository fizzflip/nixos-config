{
  config,
  inputs,
  lib,
  ...
}:
{
  nix = {
    # Distributed builds disabled by default on clients; enabled on hosts desiring offloading
    distributedBuilds = lib.mkDefault false;

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
        "https://cache.lantian.pub/lantian?priority=20"
        "https://nix-community.cachix.org?priority=30"
        "https://nixpkgs-unfree.cachix.org?priority=40"
        # "https://nix-gaming.cachix.org?priority=60"
        # "https://numtide.cachix.org?priority=70"
        # "https://niri.cachix.org?priority=40"
        # "https://nixpkgs-wayland.cachix.org?priority=45"
        # "https://chaotic-nyx.cachix.org?priority=50"
        # "https://devenv.cachix.org?priority=80"
      ];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://cache.lantian.pub/lantian"
        "https://nix-community.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
        # "https://nix-gaming.cachix.org"
        # "https://numtide.cachix.org"
        # "https://niri.cachix.org"
        # "https://nixpkgs-wayland.cachix.org"
        # "https://chaotic-nyx.cachix.org"
        # "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        # "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        # "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        # "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];

      # Store optimization & pure flake registry policy
      auto-optimise-store = false;
      flake-registry = ""; # Prevents fetching global flake-registry.json over the network
      keep-outputs = false;
      keep-derivations = false;

      # Concurrency tuning for 2 physical cores / 4 threads and 8GB RAM
      # Serializes package derivations to prevent RAM explosion while compiling with all 4 threads
      max-jobs = lib.mkDefault 1;
      cores = lib.mkDefault 4;

      # Optimize binary cache network downloads safely for memory-constrained hardware
      download-buffer-size = 33554432; # 32 MiB buffer for high-bandwidth chunk downloads
      tarball-ttl = 604800; # 7 days
      warn-dirty = false;
      auto-allocate-uids = true;
      use-cgroups = true;
      sandbox = true;
      http-connections = 25; # Balanced parallel HTTP connection pool
      connect-timeout = 5; # Fast failure on unreachable mirrors
      stalled-download-timeout = 10;
      builders-use-substitutes = lib.mkDefault true;

      # Machine capabilities for package selection
      system-features = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
    };

    # Pin nixpkgs registry and NIX_PATH to active flake input to make `nix run/shell nixpkgs#...` instant
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    # Pure flake setup without legacy channel state drift
    channel.enable = false;
  };

  # Cage nix-daemon into background slice with memory ceilings to protect desktop responsiveness.
  # Builds execute in /tmp (tmpfs) to eliminate NVMe wear, falling back to /var/tmp for massive builds.
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/tmp";
    serviceConfig = {
      Slice = "background.slice";
      Nice = 19;
      MemoryHigh = "5500M";
      MemoryMax = "7000M";
    };
  };

  # Automatic creation and aging of the build scratch fallback directory in /var/tmp
  systemd.tmpfiles.rules = [
    "d /var/tmp/nix-daemon 1777 root root 2d"
  ];
}
