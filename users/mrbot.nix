{ pkgs, ... }:
{
  users.users.mrbot = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = [
      "networkmanager"
      "adbusers"
      "docker"
      "wheel"
      "kvm"
      "i2c"
      "input"
    ];
    hashedPasswordFile = "/etc/nixos/passwords/mrbot";
  };
}
