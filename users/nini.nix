{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  winappsPkgs = inputs.winapps.packages.${pkgs.stdenv.hostPlatform.system};
in
lib.mkIf config.my.users.nini.enable {
  users.users.nini = {
    isNormalUser = true;
    description = "nini";
    hashedPasswordFile = lib.mkDefault (
      if builtins.pathExists "/etc/nixos/passwords/nini" then "/etc/nixos/passwords/nini" else null
    );
    initialHashedPassword = "$6$REDACTED$REDACTEDHASHFORHISTORYCLEANUP0000000000000000000000000000000000000000000000000000000000";
    extraGroups = [ ];
    packages = [
      # WinApps integration
      winappsPkgs.winapps
      winappsPkgs.winapps-launcher
      pkgs.freerdp
      pkgs.google-chrome
    ];
  };
}
