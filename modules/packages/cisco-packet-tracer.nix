{
  pkgs,
  lib,
  ...
}:
let
  customPacketTracer = pkgs.ciscoPacketTracer9.override {
    requireFile =
      _:
      pkgs.fetchurl {
        url = "https://github.com/andknownmaly/packettracer/releases/download/9.0.0/CiscoPacketTracer_900_Ubuntu_64bit.deb";
        sha256 = "086r5qbvvf8qarp554j4q4044vgswv3xfzv2iyvdqdzwqzac16nx";
      };
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
