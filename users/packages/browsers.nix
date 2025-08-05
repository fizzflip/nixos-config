{ pkgs, inputs }:
[
  pkgs.librewolf
  pkgs.tor-browser
  pkgs.mullvad-browser
  pkgs.ungoogled-chromium
  inputs.zen-browser.packages."${pkgs.system}".default
]
