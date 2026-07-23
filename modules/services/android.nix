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
  nixpkgs.overlays = [
    (final: prev: {
      waydroid = prev.waydroid.overrideAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          sed -i 's/iptables-legacy/iptables-nft/g' data/scripts/waydroid-net.sh
          sed -i 's/ip6tables-legacy/ip6tables-nft/g' data/scripts/waydroid-net.sh
        '';
      });
    })
  ];

  virtualisation.waydroid.enable = true;
  environment.systemPackages = [
    myAndroidStudio
    pkgs.android-tools
    pkgs.waydroid-helper
  ];
}
