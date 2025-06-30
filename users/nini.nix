{ pkgs, ... }:

{
  users.users.nini = {
    isNormalUser = true;
    description = "nini";

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages = [
      pkgs.vscodium-fhs
      pkgs.uv
      pkgs.python3
      pkgs.google-chrome
    ];
  };
}
