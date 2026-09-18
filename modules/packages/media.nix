{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf (!config.my.packages.minimal) {
  environment.systemPackages = [
    # Video/Audio
    pkgs.mpv
    pkgs.yt-dlp
    pkgs.freetube
    pkgs.ffmpeg-headless

    # Reading/Note-taking
    pkgs.mochi
    pkgs.foliate
    pkgs.obsidian
    pkgs.atril

    # Graphics & Vector Design
    pkgs.inkscape
  ];
}
