{
  inputs,
  pkgs,
  ...
}:
{
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
