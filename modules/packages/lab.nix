{ pkgs, ... }: {
  imports = [ ./cisco-packet-tracer.nix ];
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    usbmon.enable = true;
    dumpcap.enable = true;
  };
  environment.systemPackages = [
    pkgs.figma-agent
    pkgs.figma-linux
  ];
}
