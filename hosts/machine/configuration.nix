{
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "machine";

  # Disable desktop-centric preload, scx schedulers, and plymouth for headless server
  services.preload-ng.enable = false;
  services.scx-loader.enable = false;
  boot.plymouth.enable = false;

  # Minimal package set (no heavy GUI IDEs, ArtCraft, etc.)
  my.packages.minimal = true;

  # Hardware acceleration & rotational HDD protection
  my.hardware.ivyBridgeGpu.enable = true;
  my.hardware.rotationalHdd.enable = true;

  # Remote access & low-latency streaming
  my.services.sunshine.enable = true;
  my.services.avahi.enable = true;

  # Red Hat / Fedora system tuning for headless server & low-latency Sunshine streaming
  services.tuned = {
    enable = true;
    ppdSupport = false; # Headless server without battery or graphical DE
    settings = {
      reapply_sysctl = false; # Avoid stomping on bpftune dynamic kernel tuning
    };
    recommend.throughput-performance = { };
  };

  # NetworkManager with fast iwd backend, nftables, and TCP BBR
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  networking.wireless.iwd.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.nftables.enable = true;

  boot.kernelParams = [
    "audit=0"
    "nowatchdog"
    "nmi_watchdog=0"
    "rcutree.enable_rcu_lazy=1"
  ];
  boot.blacklistedKernelModules = [
    "floppy"
    "pcspkr"
    "snd_pcsp"
    "firewire_core"
    "firewire_ohci"
  ];

  # Remote access: OpenSSH daemon & client config
  my.services.ssh.enable = true;

  # Passwordless sudo for wheel group on headless server (enables unattended remote deployments)
  security.sudo.wheelNeedsPassword = false;
  security.sudo-rs.wheelNeedsPassword = false;

  # Distributed build offloading to laptop (faster Tiger Lake CPU)
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = false;
  nix.buildMachines = [
    {
      hostName = "laptop.local";
      protocol = "ssh-ng";
      system = "x86_64-linux";
      maxJobs = 1;
      speedFactor = 3;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      sshUser = "mrbot";
      sshKey = "/home/mrbot/.ssh/id_ed25519";
    }
  ];

  # EarlyOOM userspace killer (protects interactive desktop & audio from swap freezes)
  systemd.oomd.enable = false;
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    extraArgs = [
      "--avoid"
      "^(kwin|plasma|Xwayland|pipewire|wireplumber|sshd|systemd)$"
      "--prefer"
      "^(nix-daemon|nix-build|cc1plus|rustc|Web Content|firefox|chromium)$"
    ];
  };

  # Resource distribution slices & nix-daemon caging
  systemd.slices."user.slice".sliceConfig = {
    CPUWeight = 500;
    IOWeight = 500;
  };
  systemd.slices."background.slice".sliceConfig = {
    CPUWeight = 20;
    IOWeight = 10;
  };
  nix = {
    settings = {
      max-jobs = lib.mkForce 1;
      cores = lib.mkForce 1;
      auto-optimise-store = false;
    };
    daemonCPUSchedPolicy = "batch";
  };
  systemd.services.nix-daemon.serviceConfig.Slice = "background.slice";
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

  # Fallback credentials for unattended/new installations (password: pass123)
  users.users.mrbot.initialHashedPassword = lib.mkDefault "$6$REDACTED$REDACTEDHASHFORHISTORYCLEANUP0000000000000000000000000000000000000000000000000000000000";
  users.users.root.initialHashedPassword = lib.mkDefault "$6$REDACTED$REDACTEDHASHFORHISTORYCLEANUP0000000000000000000000000000000000000000000000000000000000";

  system.stateVersion = "24.11";
}
