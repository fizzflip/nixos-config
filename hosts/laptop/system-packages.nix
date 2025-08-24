{ pkgs, ... }:

{
  # Allow proprietary packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    # Video/Audio
    pkgs.freetube
    pkgs.mpv

    # Tools
    pkgs.ffmpeg-full
    pkgs.localsend
    pkgs.neovim
    pkgs.aria2
    pkgs.ncdu
    pkgs.curl
    pkgs.wget

    # Communication
    pkgs.thunderbird

    # Reading
    pkgs.foliate

    # Rust utils
    pkgs.ripgrep
    pkgs.zoxide
    pkgs.dust
    pkgs.yazi
    pkgs.bat
    pkgs.eza
    pkgs.xh
  ];
}
