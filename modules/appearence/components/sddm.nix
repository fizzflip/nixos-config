{ pkgs, inputs, ... }:
let
  sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default;
  # .override {
  #   theme = "rei";
  # };
in
{
  environment.systemPackages = [
    sddm-theme
    pkgs.kdePackages.qtmultimedia
  ];

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    theme = sddm-theme.pname;
    extraPackages = sddm-theme.propagatedBuildInputs;
    settings = {
      General = {
        GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
        InputMethod = "qtvirtualkeyboard";
      };
    };
  };
}
