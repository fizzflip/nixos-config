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

  # Disable OpenSSH daemon and Avahi mDNS network discovery
  my.services.ssh.enable = false;
  my.services.avahi.enable = false;

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

  # CachyOS latest kernel (x86-64-v4 microarchitecture with Clang ThinLTO & sched-ext support)
  boot.kernelPackages =
    inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux."linuxPackages-cachyos-latest-lto-x86_64-v4";

  # Hardware acceleration & laptop power tuning
  my.hardware.intelGpu.enable = true;
  my.hardware.powerManagement.enable = true;

  # Enable NextDNS encrypted resolver with hostname-only privacy and RAM caching
  my.services.nextdns.enable = true;

  # Enable Gaze facial authentication
  my.services.gaze.enable = true;

  # Enable spectraNET real-time network monitor, CLI, and daemon
  my.services.spectranet.enable = true;

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

    # CachyOS kernel (x86-64-v4 microarchitecture with BORE scheduler & Clang ThinLTO)
    boot.kernelPackages =
      lib.mkForce
        inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux."linuxPackages-cachyos-bore-lto-x86_64-v4";

    # Specialization-specific latency and memory optimizations
    services.bpftune.enable = lib.mkForce false;
    services.scx-loader.enable = lib.mkForce false;
    boot.kernel.sysctl."kernel.sched_autogroup_enabled" = lib.mkForce 0;

    # spectraNET network monitoring toggle (change to lib.mkForce false to disable only during gaming)
    my.services.spectranet.enable = true;

    # Low-latency gaming runtime kernel overrides: zero allocation penalty (i915 parameters omitted on Xe)
    boot.kernelParams = [
      "init_on_alloc=0"
    ];

    # Override NVMe I/O scheduler to hardware multi-queue (none) during gaming for zero-latency asset streaming
    services.udev.extraRules = lib.mkAfter ''
      ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="nvme[0-9]*n[0-9]*", ATTR{queue/scheduler}="none"
    '';
  };

  specialisation.wifi-audit.configuration = {
    # Pre-regression LTS kernel. 6.6.162 is the recommended balance.
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_6;

    # Keep module loaded so capture tools work immediately after boot.
    boot.kernelModules = [ "rtw88_8821ce" ];
    services.scx-loader.enable = false;

    # ---- Permanent driver / kernel tunables -------------------------------
    boot.extraModprobeConfig = ''
      # rtw88 RTL8821CE: prevent LPS/ASPM hard freeze and MSI instability.
      options rtw88_core disable_lps_deep=y
      options rtw88_pci disable_aspm=y
      options rtw88_pci disable_msi=y

      # Unlock 5 GHz (ch36-48) - world regdomain marks them PASSIVE-SCAN.
      options cfg80211 ieee80211_regdom=US

      # Reduce spurious disassociations while hopping/locking channels.
      options mac80211 max_nullfunc_tries=10
      options mac80211 max_probe_tries=10
      options mac80211 beacon_loss_count=10
    '';

    # Belt-and-braces runtime application: module params above are applied at
    # load; this ensures regdom + power-save state even after a device reprobe.
    systemd.services."wifi-audit-runtime" = {
      description = "WiFi audit runtime tweaks (regdom US, power_save off)";
      wantedBy = [ "multi-user.target" ];
      # Do NOT pin to wlan0 - this adapter enumerates as wlp2s0.
      after = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "wifi-audit-runtime" ''
          ${pkgs.iw}/bin/iw reg set US || true
          # Apply to every wireless interface, regardless of naming scheme
          # (wlan*, wlp*, wifi*, ...). Retry briefly for slow enumeration.
          for try in 1 2 3 4 5; do
            found=0
            for dev in /sys/class/net/*; do
              [ -d "$dev/wireless" ] || continue
              iface=$(basename "$dev")
              ${pkgs.iw}/bin/iw dev "$iface" set power_save off 2>/dev/null && found=1
            done
            [ "$found" = 1 ] && break
            sleep 1
          done
          exit 0
        '';
      };
    };

    # NetworkManager AND iwd fight over wlan0 and can reset monitor mode,
    # regulatory state or power saving. Both are disabled in this audit boot.
    networking.networkmanager.enable = lib.mkForce false;
    networking.wireless.iwd.enable = lib.mkForce false;

    # Make the audit intent visible.
    environment.variables.AUDIT_ENV = "wifi-audit";
    environment.variables.AUDIT_KERNEL = "6.6-lts";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
