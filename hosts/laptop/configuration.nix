{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "laptop";

  # Enable OpenSSH daemon and Avahi mDNS network discovery
  my.services.ssh.enable = true;
  my.services.avahi.enable = true;

  # Enable scheduled Btrfs extent-level deduplication via duperemove
  my.services.dedup.enable = true;

  # Distributed build offloading to headless server
  nix.buildMachines = [
    {
      hostName = "machine.local";
      protocol = "ssh-ng";
      system = "x86_64-linux";
      maxJobs = 1;
      speedFactor = 1;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      sshUser = config.my.user.name;
      sshKey = "/home/${config.my.user.name}/.ssh/id_ed25519";
    }
  ];

  # Enable secondary user nini in base system
  my.users.nini.enable = true;

  # Enable Lanzaboote UEFI Secure Boot
  my.security.secureboot.enable = true;

  # Bleeding-edge testing kernel for Intel Tiger Lake Iris Xe & laptop features
  boot.kernelPackages = pkgs.linuxPackages_testing;

  # Hardware acceleration & laptop power tuning
  my.hardware.intelGpu.enable = true;
  my.hardware.powerManagement.enable = true;

  # Enable NextDNS encrypted resolver with hostname-only privacy and RAM caching
  my.services.nextdns.enable = true;

  # Enable Gaze facial authentication
  my.services.gaze.enable = true;

  specialisation.lab.configuration = {
    my.services.virtualisation.enable = true;
    my.services.android.enable = true;
    users.users.${config.my.user.name}.extraGroups = [
      "adbusers"
      "podman"
      "docker"
    ];
  };

  specialisation.windows.configuration = {
    my.services.virtualisation = {
      enable = true;
      windows.enable = true;
    };
    virtualisation.libvirtd.qemu.runAsRoot = true;
    environment.systemPackages = [
      pkgs.freerdp
    ];
  };

  # Isolated specialisation for Kryoto Desktop gaming stack with CachyOS kernel
  specialisation.gaming.configuration = {
    system.nixos.tags = [ "gaming" ];
    my.packages.gaming.enable = true;

    # CachyOS kernel (x86-64-v3 microarchitecture optimized for Tiger Lake with BORE scheduler & Clang ThinLTO)
    boot.kernelPackages =
      lib.mkForce
        inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux."linuxPackages-cachyos-bore-lto-x86_64-v3";

    # Specialization-specific latency and memory optimizations
    services.bpftune.enable = lib.mkForce false;
    services.scx-loader.enable = lib.mkForce false;
    services.preload-ng.enable = lib.mkForce false;
    boot.kernel.sysctl."kernel.sched_autogroup_enabled" = lib.mkForce 0;

    # Low-latency gaming runtime kernel overrides: PSR2 selective update and zero allocation penalty
    boot.kernelParams = [
      "i915.enable_psr=2"
      "init_on_alloc=0"
    ];

    # Override NVMe I/O scheduler to hardware multi-queue (none) during gaming for zero-latency asset streaming
    services.udev.extraRules = lib.mkAfter ''
      ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="nvme[0-9]*n[0-9]*", ATTR{queue/scheduler}="none"
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
