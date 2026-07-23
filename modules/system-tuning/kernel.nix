{
  pkgs,
  lib,
  ...
}:
{
  boot.kernelPackages = pkgs.linuxPackages_zen;

  services.scx-loader = {
    enable = true;
    config = {
      # lavd is mathematically the best for a 2-core laptop
      default_sched = "scx_lavd";
      default_mode = "Auto";

      scheds.scx_lavd = {
        # --autopower reads your laptop's battery/AC state directly via EPP
        auto_mode = [ "--autopower" ];
        powersave_mode = [ "--powersave" ];
        gaming_mode = [ "--performance" ];
      };

      scheds.scx_bpfland = {
        auto_mode = [
          "-m"
          "auto"
        ];
        # -w (wake-affine) keeps threads pinned to their L1/L2 cache, vital for dual-cores
        gaming_mode = [
          "-m"
          "performance"
          "-w"
        ];
        # Official CachyOS powersave flags: 20ms slice, idle tuning
        powersave_mode = [
          "-s"
          "20000"
          "-m"
          "powersave"
          "-I"
          "100"
          "-t"
          "100"
        ];
      };
    };
  };

  security.sudo.extraRules = [
    {
      users = [ "mrbot" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/scxctl";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Kernel Parameters to reduce wakeups, audit overhead, force PCIe ASPM, NVMe APST power states, AHCI LPM, THP madvise, PSI tracking, USB autosuspend, and disable mitigations
  boot.kernelParams = [
    "audit=0"
    "nmi_watchdog=0"
    "quiet"
    "loglevel=3"
    "pcie_aspm=force"
    "nvme_core.default_ps_max_latency_us=0"
    "ahci.mobile_lpm=1"
    "transparent_hugepage=madvise"
    "psi=1"
    "usbcore.autosuspend=2"
    "mitigations=off"
  ];

  # Load network congestion control modules
  boot.kernelModules = [ "tcp_bbr" ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;

    # TCP BBR Congestion Control & Network Optimizations
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_mtu_probing" = 1;
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.ipv4.tcp_slow_start_after_idle" = 0;

    # Network Socket Buffer Tuning (Max 16MB buffer bounds)
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";

    # IPv6 Privacy Extensions (Safely typed as string "2" with lib.mkDefault)
    "net.ipv6.conf.all.use_tempaddr" = lib.mkDefault "2";
    "net.ipv6.conf.default.use_tempaddr" = lib.mkDefault "2";
  };
}
