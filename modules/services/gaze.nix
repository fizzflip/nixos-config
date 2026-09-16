{ inputs, ... }: {
  imports = [ inputs.gaze.nixosModules.default ];
  services.gaze = {
    enable = true;
    gui.enable = true;
  };
}
