{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_zen;

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
