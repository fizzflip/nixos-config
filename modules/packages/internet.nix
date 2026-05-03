{ pkgs, ... }:
{
  environment.systemPackages = [
    # Browsers
    # pkgs.librewolf
    # pkgs.tor-browser
    pkgs.mullvad-browser
    pkgs.ungoogled-chromium

    # Communication
    # pkgs.vesktop
    pkgs.thunderbird

    # Torrent
    pkgs.qbittorrent-enhanced
  ];
}
