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

    # Monitoring
    pkgs.btop
    pkgs.htop
    pkgs.fastfetch

    # Nix
    pkgs.nixd
    pkgs.nixfmt
    pkgs.nix-tree

    # Archive Tools
    pkgs._7zz-rar

    # Image manipulation
    pkgs.chafa
    pkgs.imagemagick
  ];
}
