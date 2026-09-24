{ config, ... }:
let
  cfg = config.my.user;
in
{
  users.users.${cfg.name} = {
    isNormalUser = true;
    shell = cfg.shell;
    extraGroups = cfg.extraGroups;
    hashedPasswordFile =
      if cfg.hashedPasswordFile != null && builtins.pathExists cfg.hashedPasswordFile
      then cfg.hashedPasswordFile
      else null;
  };
}
