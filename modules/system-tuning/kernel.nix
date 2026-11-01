{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_testing;

  services.scx-loader = {
    enable = true;
    config = {
      # scx_bpfland provides optimal responsiveness without Core Compaction bottlenecks
      default_sched = "scx_bpfland";
      default_mode = "Auto";

      scheds.scx_lavd = {
        # --autopower reads laptop EPP state; --no-core-compaction prevents parking Core 1 on dual-core CPU
        auto_mode = [
          "--autopower"
          "--no-core-compaction"
        ];
        powersave_mode = [
          "--powersave"
          "--no-core-compaction"
        ];
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

  # Kernel Parameters: reduce wakeups, audit overhead, enable PCIe ASPM powersave, THP madvise, PSI tracking, USB autosuspend, and memory sanitization
  boot.kernelParams = [
    "audit=0"
    "nmi_watchdog=0"
    "pcie_aspm=force"
    "pcie_aspm.policy=powersave"
    "transparent_hugepage=madvise"
    "psi=1"
    "usbcore.autosuspend=2"
    "split_lock_mitigate=0"
    "nowatchdog"
    "rcutree.enable_rcu_lazy=1"

    # Kernel Self-Protection (KSPP): Zero heap/page allocations & shuffle free list against heap spray exploits
    "init_on_alloc=1"
    "page_alloc.shuffle=1"
  ];

  # Blacklist obsolete network protocols and legacy unmaintained filesystems prone to local privilege escalation
  boot.blacklistedKernelModules = [
    # Obsolete network protocols
    "dccp"
    "sctp"
    "rds"
    "tipc"
    "n-hdlc"
    "ax25"
    "netrom"
    "x25"
    "rose"
    "decnet"
    "econet"
    "af_802154"
    "ipx"
    "appletalk"
    "psnap"
    "p8023"
    "p8022"
    "can"
    "atm"

    # Legacy / unmaintained filesystems
    "cramfs"
    "freevxfs"
    "jffs2"
    "hfs"
    "hfsplus"
    "hpfs"
    "adfs"
    "affs"
    "befs"
    "bfs"
    "efs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"

    # Obsolete peripheral bus protocols
    "firewire-core"
    "firewire_ohci"
  ];

  # Load network congestion control modules
  boot.kernelModules = [ "tcp_bbr" ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
    "vm.compaction_proactiveness" = 0;
    "vm.page_lock_unfairness" = 1;

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
