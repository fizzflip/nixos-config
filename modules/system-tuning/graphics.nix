{ pkgs, ... }: {
  # Enable OpenGL/Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      # Core drivers for 11th Gen (Tiger Lake)
      pkgs.intel-media-driver # Primary driver for Gen 9+
      pkgs.vpl-gpu-rt # Hardware video encoding/decoding
      pkgs.intel-compute-runtime # Gen 12+ OpenCL NEO & Level Zero compute runtime
      pkgs.libvdpau-va-gl # VDPAU-to-VA-API bridge
    ];
    extraPackages32 = [
      pkgs.pkgsi686Linux.intel-media-driver
      pkgs.pkgsi686Linux.libvdpau-va-gl
    ];
  };

  # Mesa optimizations (let libva auto-detect iHD driver naturally)
  environment.sessionVariables = {
    MESA_GL_THREAD = "true";
    MESA_DISK_CACHE_SINGLE_FILE = "1";
  };

  # Enable Intel GuC/HuC hardware submission, Framebuffer Compression (FBC), and stable PSR1
  boot.kernelParams = [
    "i915.enable_guc=3"
    "i915.enable_fbc=1"
    "i915.enable_psr=1"
  ];
}
