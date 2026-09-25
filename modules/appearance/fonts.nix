{ pkgs, ... }: {
  fonts.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.mononoki

    pkgs.stix-two

    pkgs.corefonts
    pkgs.open-sans

    pkgs.dm-sans
    pkgs.dm-mono

    pkgs.maple-mono.NF

    pkgs.noto-fonts
    pkgs.font-awesome
    pkgs.material-icons
    pkgs.noto-fonts-color-emoji
    pkgs.noto-fonts-cjk-sans
    pkgs.helvetica-neue-lt-std
    pkgs.material-design-icons
  ];
}
