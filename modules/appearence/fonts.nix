{ pkgs, ... }:

{
  fonts.packages = [
    pkgs.nerd-fonts.noto
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.mononoki

    pkgs.stix-two
    pkgs.iosevka

    pkgs.corefonts
    pkgs.open-sans

    pkgs.dm-sans
    pkgs.dm-mono

    pkgs.cascadia-code
    pkgs.maple-mono.NF
  ];
}
