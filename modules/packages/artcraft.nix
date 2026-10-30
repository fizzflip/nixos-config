{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.packages.artcraft;
  craftPkgs = inputs.craftapps.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      craftPkgs.deckcraft
      craftPkgs.gridcraft
      craftPkgs.pdfcraft
      craftPkgs.photocraft
      craftPkgs.vectorcraft
      craftPkgs.wordcraft
    ];
  };
}
