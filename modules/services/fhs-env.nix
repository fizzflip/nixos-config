{ pkgs, ... }:
{
  programs.nix-ld.enable = true;
  environment.systemPackages = [ pkgs.steam-run ];
}
