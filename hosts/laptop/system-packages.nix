{ config, pkgs, ... }:

{
  # Allow proprietary packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Video/Audio
    mpv
    miru
    freetube

    neovim

    # Tools
    localsend
    ncdu
    ffmpeg-full
    aria2
    curl
    wget

    # Browser
    # ungoogled-chromium

    # Communication
    thunderbird

    # Reading
    foliate

    # openai-whisper-cpp
    onlyoffice-desktopeditors
    ffmpegthumbnailer

    # Rust utils
    bat
    ripgrep
    eza
    zoxide
    xh
    dust
    yazi
  ];
}
