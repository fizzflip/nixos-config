{ ... }: {
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../../modules/packages/default.nix
  ];
}
