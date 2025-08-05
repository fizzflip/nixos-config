{ pkgs, inputs, ... }:
let
  sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default;
  # .override {
  #   theme = "rei";
  # };
in
{
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = [ pkgs.kdePackages.plasma-browser-integration ];

  environment.systemPackages = [
    pkgs.kdePackages.kcalc
    pkgs.kdePackages.partitionmanager

    pkgs.kdePackages.akregator

    pkgs.python312Packages.kde-material-you-colors

    sddm-theme
    pkgs.kdePackages.qtmultimedia
  ];

  services.displayManager.sddm = {
    enable = true;
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

  # hardware.bluetooth = {
  #   enable = true;
  #   # powerOnBoot = true; # optional, auto-power on at boot
  #   settings.General.Experimental = true; # shows battery % and extra info
  # };

  services.fwupd.enable = true;
}
