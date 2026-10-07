{ pkgs, ... }: {
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;
  environment.systemPackages = [
    pkgs.android-tools
    pkgs.android-studio
    pkgs.waydroid-helper
  ];
}
