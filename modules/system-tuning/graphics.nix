{ pkgs, ... }: {
  # Enable OpenGL/Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Core drivers for 11th Gen (Tiger Lake)
      intel-media-driver # LIBVA_DRIVER_NAME=iHD (primary for Gen 9+)
      vpl-gpu-rt # For hardware video encoding/decoding
      libvdpau-va-gl # VDPAU-to-VA-API bridge
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  # Use iHD driver (intel-media-driver) for modern Intel and Mesa optimizations
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
    MESA_GL_THREAD = "true";
    MESA_DISK_CACHE_SINGLE_FILE = "1";
  };

  # Enable Intel GuC/HuC hardware submission, Framebuffer Compression (FBC), PSR2, and Fastboot
  boot.kernelParams = [
    "i915.enable_guc=3"
    "i915.enable_fbc=1"
    "i915.enable_psr=2"
    "i915.fastboot=1"
  ];
}
