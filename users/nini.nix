{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.my.users.nini.enable {
  users.users.nini = {
    isNormalUser = true;
    description = "nini";
    hashedPasswordFile = "/etc/nixos/passwords/nini";
    packages = [
      pkgs.vscodium-fhs
      pkgs.uv
      pkgs.python3
      pkgs.google-chrome
    ];
  };
}
