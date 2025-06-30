{ config, pkgs, ... }:

{
  # Allow proprietary packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    # Video/Audio
    pkgs.mpv
    pkgs.miru
    pkgs.freetube

    pkgs.neovim

    # Tools
    pkgs.localsend
    pkgs.ncdu
    pkgs.ffmpeg-full
    pkgs.aria2
    pkgs.curl
    pkgs.wget

    # Browser
    # ungoogled-chromium

    # Communication
    pkgs.thunderbird

    # Reading
    pkgs.foliate

    # openai-whisper-cpp
    pkgs.onlyoffice-desktopeditors
    pkgs.ffmpegthumbnailer

    # Rust utils
    pkgs.bat
    pkgs.ripgrep
    pkgs.eza
    pkgs.zoxide
    pkgs.xh
    pkgs.dust
    pkgs.yazi
  ];
}
