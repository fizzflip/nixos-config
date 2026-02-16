{ pkgs, ... }:
{
  # Enable OpenGL/Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Core drivers for 11th Gen (Tiger Lake)
      intel-media-driver # LIBVA_DRIVER_NAME=iHD (primary for Gen 9+)
      intel-ocl # OpenCL support
      intel-gmmlib # Graphics Memory Management Library
      intel-compute-runtime # OpenCL compute runtime

      # VPL (replaces deprecated media-sdk)
      vpl-gpu-rt # For hardware video encoding/decoding

      # Additional support
      mesa # OpenGL/Vulkan
      vulkan-tools # Vulkan utilities
      libvdpau # VDPAU support
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

  # Optional: If you have display issues, check your device ID first
  # Run: nix-shell -p pciutils --run "lspci -nn | grep VGA"
  # Then uncomment and add your device ID:
  # boot.kernelParams = [ "i915.force_probe=YOUR_DEVICE_ID" ];

  hardware.enableAllFirmware = true;
}
