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
    extraPackages = with pkgs; [
      intel-ocl
      intel-gmmlib
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      # intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      intel-compute-runtime
      ocl-icd
      libvdpau
      libvdpau-va-gl

      mesa
      vpl-gpu-rt
      vulkan-tools
      # nvidia-vaapi-driver
      # nv-codec-headers-12
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      vaapiVdpau
      mesa
      libvdpau-va-gl
    ];
  };

  hardware.enableAllFirmware = true;
}
