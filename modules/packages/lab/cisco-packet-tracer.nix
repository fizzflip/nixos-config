{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = [ pkgs.ciscoPacketTracer9 ];
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      packettracer9 = {
        executable = "${lib.getExe pkgs.ciscoPacketTracer9}";
        desktop = "${pkgs.ciscoPacketTracer9}/share/applications/cisco-packet-tracer-9.desktop";
        extraArgs = [
          "--net=none"
          "--noprofile"
        ];
      };
    };
  };
}
