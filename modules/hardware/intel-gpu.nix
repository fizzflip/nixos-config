{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.hardware.intelGpu;
in
{
  config = lib.mkIf cfg.enable {
    # Core drivers for 11th Gen (Tiger Lake) Intel Iris Xe Graphics
    hardware.graphics = {
      extraPackages = [
        pkgs.intel-media-driver # Primary VA-API driver for Gen 9+
        pkgs.vpl-gpu-rt # Hardware video encoding/decoding runtime
        pkgs.intel-compute-runtime # Gen 12+ OpenCL NEO & Level Zero compute runtime
        pkgs.libvdpau-va-gl # VDPAU-to-VA-API bridge
      ];
      extraPackages32 = [
        pkgs.pkgsi686Linux.intel-media-driver
        pkgs.pkgsi686Linux.libvdpau-va-gl
      ];
    };

    # Early KMS initialization in initrd
    boot.initrd.kernelModules = [ "i915" ];

    # Enable Intel GuC/HuC hardware submission, Framebuffer Compression (FBC), and stable PSR1
    boot.kernelParams = [
      "i915.enable_guc=3"
      "i915.enable_fbc=1"
      "i915.enable_psr=1"
    ];
  };
}
