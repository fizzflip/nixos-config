{ config, ... }:
let
  cfg = config.my.user;
in
{
  users.users.${cfg.name} = {
    isNormalUser = true;
    shell = cfg.shell;
    extraGroups = cfg.extraGroups;
    hashedPasswordFile = cfg.hashedPasswordFile;
  };
}
