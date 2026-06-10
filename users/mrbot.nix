{ pkgs, ... }:
{
  users.users.mrbot = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
      "i2c"
      "input"
    ];
    hashedPasswordFile = "/etc/nixos/passwords/mrbot";
  };
}
