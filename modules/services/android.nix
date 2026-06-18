{ pkgs, ... }:
let
  myCustomSdk = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "CinnamonBun" ];
    buildToolsVersions = [ "37.0.0" ];
    includeSystemImages = false;
    includeEmulator = false;
    includeNDK = false;
  };
  myAndroidStudio = pkgs.android-studio.withSdk myCustomSdk.androidsdk;
in
{
  nixpkgs.config.android_sdk.accept_license = true;
  virtualisation.waydroid.enable = true;
  environment.systemPackages = [
    myAndroidStudio
    pkgs.android-tools
    pkgs.waydroid-helper
  ];
}
