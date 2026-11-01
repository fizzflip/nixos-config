{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf ((config.my.user.shell.pname or "") == "nushell") {
  programs.nushell.enable = true;
  environment.systemPackages = [
    pkgs.nushell
    pkgs.nushellPlugins.formats
    pkgs.nushellPlugins.gstat
    pkgs.nushellPlugins.highlight
    pkgs.nushellPlugins.query
    pkgs.nushellPlugins.polars
    pkgs.nushellPlugins.skim
  ];

  environment.shells = [
    pkgs.nushell
  ];
}
