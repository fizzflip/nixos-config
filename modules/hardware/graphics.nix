{ pkgs, ... }:

{
  # Intel Graphics (HW-Accel)
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.intel-ocl
      pkgs.intel-gmmlib
      pkgs.intel-media-driver # LIBVA_DRIVER_NAME=iHD
      # intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      pkgs.intel-compute-runtime
      pkgs.ocl-icd
      pkgs.libvdpau
      pkgs.libvdpau-va-gl

      pkgs.mesa
      pkgs.vpl-gpu-rt
      pkgs.vulkan-tools
    ];
    extraPackages32 = [
      pkgs.pkgsi686Linux.intel-media-driver
      pkgs.pkgsi686Linux.vaapiVdpau
      pkgs.pkgsi686Linux.mesa
      pkgs.pkgsi686Linux.libvdpau-va-gl
    ];
  };

  hardware.enableAllFirmware = true;
}
