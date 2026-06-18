{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    # Browsers
    # pkgs.librewolf
    # pkgs.tor-browser
    pkgs.mullvad-browser
    pkgs.ungoogled-chromium
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Communication
    # pkgs.vesktop
    pkgs.thunderbird

    # Torrent
    pkgs.qbittorrent-enhanced
  ];
}
