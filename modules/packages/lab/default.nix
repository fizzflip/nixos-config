{ pkgs, ... }: {
  imports = [
    ./wireshark.nix
  ];

  environment.systemPackages = [
    pkgs.oracle-instantclient
    pkgs.freerdp
    pkgs.rlwrap
  ];
}
