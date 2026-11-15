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
    pkgs.ffmpeg-headless

    # Reading/Note-taking
    pkgs.mochi
    pkgs.foliate
    pkgs.obsidian
  ]
  ++
    lib.optionals (inputs ? opentubex && inputs.opentubex.packages ? ${pkgs.stdenv.hostPlatform.system})
      [
        (inputs.opentubex.packages.${pkgs.stdenv.hostPlatform.system}.opentubex
          or inputs.opentubex.packages.${pkgs.stdenv.hostPlatform.system}.default
        )
      ]
  ++ lib.optionals (inputs.metrolist.packages ? ${pkgs.stdenv.hostPlatform.system}) [
    inputs.metrolist.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
