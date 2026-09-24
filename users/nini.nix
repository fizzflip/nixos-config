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
    hashedPasswordFile = lib.mkDefault (
      if builtins.pathExists /etc/nixos/passwords/nini then "/etc/nixos/passwords/nini" else null
    );
    initialPassword = "nini";
    extraGroups = [
      "podman"
      "kvm"
    ];
    packages = [
      pkgs.winboat
      pkgs.freerdp
      pkgs.podman-compose
      pkgs.vscodium-fhs
      pkgs.uv
      pkgs.python3
      pkgs.google-chrome
    ];
  };
}
