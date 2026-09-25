{ pkgs, ... }: {
  imports = [
    # ./cisco-packet-tracer.nix
    ./wireshark.nix
  ];

  environment.systemPackages = [
    pkgs.oracle-instantclient
    pkgs.freerdp
    pkgs.rlwrap
  ];
}
