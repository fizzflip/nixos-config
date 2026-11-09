{
  pkgs,
  lib,
  ...
}:
let
  plymouth-theme = "splash";
in
{
  boot.plymouth = {
    enable = lib.mkDefault true;
    theme = plymouth-theme;
    themePackages = [
      (pkgs.adi1090x-plymouth-themes.override {
        selected_themes = [ plymouth-theme ];
      })
    ];
  };
}
