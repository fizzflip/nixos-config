{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  programs.nh.enable = true;
  environment.systemPackages = [
    # Transfer
    pkgs.curl
    pkgs.aria2

    # File management
    pkgs.dust
    pkgs.ncdu
    pkgs.yazi
    pkgs.file

    # Searching
    pkgs.fd
    pkgs.bat
    pkgs.skim
    pkgs.ripgrep

    # Monitoring & Power Diagnostics
    pkgs.btop
    pkgs.htop
    pkgs.fastfetch
    pkgs.powertop
    pkgs.hdparm
    inputs.packaging-nixos-apps.packages.${pkgs.stdenv.hostPlatform.system}.rockbottom

    # Nix & Linters
    pkgs.nixd
    pkgs.nixfmt
    pkgs.statix
    pkgs.deadnix
    pkgs.nix-tree

    # Archive Tools
    pkgs._7zz
  ]
  ++ lib.optionals (!config.my.packages.minimal) [
    # Clipboard utilities
    pkgs.wl-clipboard
    pkgs.xclip

    # Image manipulation
    pkgs.chafa
    pkgs.imagemagick
  ];
}
