{ pkgs, ... }: {
  imports = [ ./cisco-packet-tracer.nix ];
  environment.systemPackages = [
    pkgs.wireshark
    pkgs.figma-agent
    pkgs.figma-linux
  ];
}
