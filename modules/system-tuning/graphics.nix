{ pkgs, ... }: {
  # Enable OpenGL/Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Core drivers for 11th Gen (Tiger Lake)
      intel-media-driver # LIBVA_DRIVER_NAME=iHD (primary for Gen 9+)

      intel-gmmlib # Graphics Memory Management Library
      intel-compute-runtime # OpenCL compute runtime

      # VPL (replaces deprecated media-sdk)
      vpl-gpu-rt # For hardware video encoding/decoding

      # Additional support
      mesa # OpenGL/Vulkan
      libvdpau-va-gl # VDPAU-to-VA-API bridge
      ocl-icd # OpenCL ICD loader
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      mesa
      libvdpau-va-gl
    ];
  };

  # Use iHD driver (intel-media-driver) for modern Intel
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
  };

  # Enable Intel GuC/HuC hardware submission & video scheduling offload
  boot.kernelParams = [ "i915.enable_guc=3" ];
}
