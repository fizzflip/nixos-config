{ pkgs, ... }: {
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

  # Load network congestion control modules
  boot.kernelModules = [ "tcp_bbr" ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;

    # TCP BBR Congestion Control & Network Optimizations
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_mtu_probing" = 1;
  };
}
