{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
lib.mkIf (!config.my.packages.minimal) {
  environment.systemPackages = [
    # Browsers
    pkgs.mullvad-browser
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Email
    pkgs.thunderbird

    # Torrent
    pkgs.qbittorrent-enhanced
  ];
}
