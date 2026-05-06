{ pkgs, ... }:
let
  plymouth-theme = "splash";
in
{
  boot.plymouth = {
    enable = true;
    theme = plymouth-theme;
    themePackages = [
      (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ plymouth-theme ]; })
    ];
  };
}
