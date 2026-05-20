{ pkgs, inputs, ... }:
{
  nix.settings = {
    extra-substituters = [
      "https://xddxdd.cachix.org?priority=50"
      "https://cache.garnix.io?priority=60"
      "https://attic.xuyh0120.win/lantian?priority=70"
    ];
    extra-trusted-public-keys = [
      "xddxdd.cachix.org-1:ay1HJyNDYmlSwj5NXQG065C8LfoqqKaTNCyzeixGjf8="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  boot.kernelPackages =
    pkgs.linuxPackagesFor
      inputs.nix-cachyos-kernel.packages.${pkgs.stdenv.hostPlatform.system}.linux-cachyos-latest-lto-x86_64-v4;
  #  pkgs.linuxPackages_zen;

  # Load network congestion control modules
  boot.kernelModules = [ "tcp_bbr" ];

  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
  };

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;

    # TCP BBR Congestion Control & Network Optimizations
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_mtu_probing" = 1;
  };
}
