{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nushell
    nushellPlugins.formats
    nushellPlugins.gstat
    nushellPlugins.highlight
    nushellPlugins.query
    nushellPlugins.polars
    nushellPlugins.skim
  ];

  environment.shells = with pkgs; [
    nushell
  ];
}
