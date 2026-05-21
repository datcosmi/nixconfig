{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.hardware;
  isNvidia = cfg.gpu.vendor == "nvidia";
in {
  config = lib.mkIf isNvidia {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      open = cfg.gpu.openDrivers;
      modesetting.enable = true;
      videoAcceleration = true;
      nvidiaSettings = true;
      package = cfg.gpu.nvidiaPackage;

      powerManagement = lib.mkIf cfg.needSuspend {
        enable = true;
        finegrained = cfg.hybrid && cfg.gpu.openDrivers;
      };

      prime = lib.mkIf cfg.hybrid {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = cfg.prime.intelBusId;
        nvidiaBusId = cfg.prime.nvidiaBusId;
      };
    };

    hardware.graphics.extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };
}
