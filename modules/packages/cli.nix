{ pkgs, ... }: {
  programs.nh.enable = true;
  environment.systemPackages = [
    # Transfer
    pkgs.curl
    pkgs.aria2
    pkgs.localsend
    pkgs.megabasterd

    # File management
    pkgs.dust
    pkgs.ncdu
    pkgs.yazi

    # Searching
    pkgs.bat
    pkgs.skim
    pkgs.fd
    pkgs.ripgrep

    # Monitoring
    pkgs.btop
    pkgs.htop
    pkgs.fastfetch

    # Nix
    pkgs.nil
    pkgs.nixd
    pkgs.nixfmt
    pkgs.nix-tree

    # Archive Tools
    pkgs._7zz-rar
  ];
}
