{ pkgs, ... }: {
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

    # Nix & Linters
    pkgs.nixd
    pkgs.nixfmt
    pkgs.statix
    pkgs.deadnix
    pkgs.nix-tree

    # Archive Tools
    pkgs._7zz

    # Image manipulation
    pkgs.chafa
    pkgs.imagemagick
  ];
}
