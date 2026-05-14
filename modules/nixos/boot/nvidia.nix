{
  lib,
  config,
  ...
}: let
  cfg = config.my.hardware;
in {
  config = lib.mkIf (cfg.gpu == "nvidia") {
    boot.initrd.kernelModules = lib.mkAfter [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    boot.kernelParams = lib.mkAfter [
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      "nvidia.NVreg_OpenRmEnableUnsupportedGpus=1"
    ];

    boot.blacklistedKernelModules = ["nouveau"];
  };
}
