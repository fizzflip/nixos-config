{ inputs, ... }:
{
  imports = [ inputs.silentSDDM.nixosModules.default ];
  programs.silentSDDM = {
    enable = true;
    theme = "catppuccin-mocha";
    # settings = { ... }; see example in module
  };
}
