{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.noto
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono

    stix-two

    iosevka

    noto-fonts
    noto-fonts-cjk-sans

    corefonts
    open-sans
    font-awesome
    dm-sans
    cascadia-code
    maple-mono.NF
    material-icons
    material-design-icons

    nerd-fonts.mononoki
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    dm-mono
  ];
}
