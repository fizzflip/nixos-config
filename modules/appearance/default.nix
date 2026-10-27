{ ... }: {
  imports = [
    ./gtk.nix
    ./fonts.nix
    ./components/sddm.nix
    ./desktop-environment/default.nix
  ];
}
