{ pkgs, ... }:

{
  users.users.nini = {
    isNormalUser = true;
    description = "nini";

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages = with pkgs; [
      vscodium-fhs
      uv
      python3
      google-chrome
    ];
  };
}
