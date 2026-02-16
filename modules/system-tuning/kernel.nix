{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_lqx;
  services.scx.enable = true;
}
