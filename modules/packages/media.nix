{
  config,
  inputs,
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
  ]
  ++ lib.optionals (inputs.metrolist.packages ? ${pkgs.stdenv.hostPlatform.system}) [
    inputs.metrolist.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
