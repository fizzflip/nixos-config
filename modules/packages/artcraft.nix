{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.packages.artcraft;
  artcraftPkgs = inputs.artcraft.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  config = lib.mkIf cfg.enable {
    fonts.packages = [
      artcraftPkgs.craft-fonts
    ];

    environment.systemPackages = [
      artcraftPkgs.deckcraft
      artcraftPkgs.gridcraft
      artcraftPkgs.pdfcraft
      artcraftPkgs.photocraft
      artcraftPkgs.vectorcraft
      artcraftPkgs.wordcraft
    ];
  };
}
