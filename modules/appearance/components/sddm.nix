{
  config,
  lib,
  inputs,
  ...
}:
let
  env = config.my.desktop.environment;
in
{
  imports = [ inputs.silentSDDM.nixosModules.default ];
  config = lib.mkIf (env == "niri" || env == "kde") {
    programs.silentSDDM = {
      enable = true;
      theme = "catppuccin-mocha";
      # settings = { ... }; see example in module
    };
  };
}
