{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.noto
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.mononoki

    stix-two
    iosevka

    corefonts
    open-sans

    dm-sans
    dm-mono

    cascadia-code
    maple-mono.NF
  ];
}
