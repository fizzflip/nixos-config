{
  config,
  lib,
  ...
}:
{
  options.my.packages = {
    minimal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When enabled, installs only core CLI tools and desktop essentials, omitting heavy IDEs, media, internet applications, and flatpaks.";
    };

    artcraft = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = !config.my.packages.minimal;
        description = "Enable the ArtCraft applications (PdfCraft, WordCraft, DeckCraft, GridCraft, VectorCraft, PhotoCraft) from github:Devitek/artcraft-nixos.";
      };
    };
  };

  imports = [
    ./cli.nix
    ./media.nix
    ./internet.nix
    ./development.nix
    ./artcraft.nix
  ];
}
