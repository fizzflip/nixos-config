{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.my.hardware.intelGpu;
in
{
  options.my.hardware.intelGpu = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Intel Gen 11/12 GPU acceleration packages, early KMS, and kernel driver parameters.";
    };

    driver = lib.mkOption {
      type = lib.types.enum [
        "i915"
        "xe"
      ];
      default = "i915";
      description = "Underlying kernel graphics driver to bind to the Intel GPU.";
    };

    pciId = lib.mkOption {
      type = lib.types.str;
      default = "9a78";
      description = "Hexadecimal PCI device ID for 11th Gen Tiger Lake GPU.";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.optionalAttrs (options ? hardware.intelgpu) {
        hardware.intelgpu.driver = cfg.driver;
      })
      {
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

        # Early KMS initialization in initrd (fallback if nixos-hardware is absent)
        boot.initrd.kernelModules = lib.mkIf (!(options ? hardware.intelgpu)) [ cfg.driver ];

        # Driver-specific kernel parameters
        boot.kernelParams =
          if cfg.driver == "xe" then
            [
              "i915.force_probe=!${cfg.pciId}"
              "xe.force_probe=${cfg.pciId}"
            ]
          else
            [
              "i915.enable_guc=3"
              "i915.enable_fbc=1"
              "i915.enable_psr=1"
              "i915.fastboot=1"
            ];

        # Hardware-accelerated media environment variables
        environment.sessionVariables = {
          LIBVA_DRIVER_NAME = "iHD";
          VDPAU_DRIVER = "va_gl";
        };
      }
    ]
  );
}
