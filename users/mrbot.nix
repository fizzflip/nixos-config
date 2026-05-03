{ pkgs, ... }:
{
  users.users.mrbot = {
    isNormalUser = true;
    shell = pkgs.zsh;
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
