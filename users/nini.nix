{ pkgs, ... }:

{
  users.users.nini = {
    isNormalUser = true;
    description = "nini";
    hashedPassword = "$6$YZ/clpXtw2JFnWHM$ATq5xI6y6HHl2TzxBPDzHc0XAyjyh0MI45Nv2Zb9iuiATt3GQR.citUHDB28X9Hz1HbESybMpoMl.KkDmx53T1";

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
