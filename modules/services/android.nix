{ pkgs, ... }:
{
  virtualisation.waydroid.enable = true;
  environment.systemPackages = [
    pkgs.android-tools
    pkgs.android-studio
    pkgs.waydroid-helper
    pkgs.android-translation-layer
  ];
}
