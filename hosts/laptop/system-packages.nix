{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.mpv
    pkgs.ffmpeg-full
    
    pkgs.curl
    pkgs.aria2
    pkgs.localsend

    pkgs.dust
    pkgs.ncdu
    pkgs.yazi

    pkgs.bat
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
    pkgs.p7zip-rar
  ];
}
