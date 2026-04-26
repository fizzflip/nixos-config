{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.mpv
    pkgs.ffmpeg-full

    # Transfer
    pkgs.curl
    pkgs.aria2
    pkgs.localsend

    # File management
    pkgs.dust
    pkgs.ncdu
    pkgs.yazi

    # Searching
    pkgs.bat
    pkgs.skim
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
    pkgs._7zip-zstd-rar
  ];
}
