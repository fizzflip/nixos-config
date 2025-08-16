{ pkgs, inputs, ...}:
  let sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default.override { theme = "ken"; }; in {
   # include the test package which can be run using test-sddm-silent
   environment.systemPackages = [ sddm-theme sddm-theme.test ];
   qt.enable = true;
   services.displayManager.sddm = {
      package = pkgs.kdePackages.sddm; # use qt6 version of sddm
      wayland.enable = true;
      enable = true;
      theme = sddm-theme.pname;
      extraPackages = sddm-theme.propagatedBuildInputs;
      settings = {
        # required for styling the virtual keyboard
        General = {
          GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
          InputMethod = "qtvirtualkeyboard";
        };
      };
   };
}