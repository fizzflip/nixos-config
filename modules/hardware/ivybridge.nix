{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.hardware.ivyBridgeGpu;
in
{
  options.my.hardware.ivyBridgeGpu = {
    enable = lib.mkEnableOption "Intel HD Graphics 2500 (Ivy Bridge Gen7) hardware acceleration & VA-API drivers";
  };

  config = lib.mkIf cfg.enable {
    hardware.cpu.intel.updateMicrocode = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.intel-vaapi-driver
        pkgs.libvdpau-va-gl
      ];
      extraPackages32 = [
        pkgs.pkgsi686Linux.intel-vaapi-driver
        pkgs.pkgsi686Linux.libvdpau-va-gl
      ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "i965";
      MESA_DISK_CACHE_SINGLE_FILE = "1";
      MESA_DISK_CACHE_MAX_SIZE = "128MB";
      MESA_GL_THREAD = lib.mkForce "false";
    };
  };
}
