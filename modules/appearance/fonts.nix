{ pkgs, ... }: {
  systemd.tmpfiles.rules = [
    "L+ /usr/share/fonts - - - - /run/current-system/sw/share/X11/fonts"
  ];

  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "STIX Two Text"
          "Noto Serif"
        ];
        sansSerif = [
          "Open Sans"
          "Noto Sans"
          "Noto Sans CJK SC"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Maple Mono NF"
          "FiraCode Nerd Font"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
    packages = [
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
  };
}
