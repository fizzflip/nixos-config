{
  pkgs,
  lib,
  ...
}:
let
  version = "9.0.1";
  debName = "CiscoPacketTracer_901_Ubuntu_64bit.deb";
  debHash = "sha256-NoPdh+d5iFNyrpo1wabllNEvST5knnxpdAhynBRZR5s=";
  localDebCache = "/var/cache/cisco/${debName}";

  # Automated resolution: use local cached deb if present, else fetch from verified mirror
  debSource =
    if builtins.pathExists localDebCache then
      localDebCache
    else
      pkgs.fetchurl {
        url = "https://archive.org/download/packettracer901/${debName}";
        hash = debHash;
      };

  customPacketTracer = pkgs.ciscoPacketTracer9.override {
    requireFile = _: debSource;
  };
in
{
  environment.systemPackages = [ customPacketTracer ];
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      packettracer9 = {
        executable = "${lib.getExe customPacketTracer}";
        desktop = "${customPacketTracer}/share/applications/cisco-packet-tracer-9.desktop";
        extraArgs = [
          "--net=none"
          "--noprofile"
        ];
      };
    };
  };
}
