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
    assertions = [
      {
        assertion = !cfg.hybrid || (cfg.prime.intelBusId != null && cfg.prime.nvidiaBusId != null);
        message = "my.hardware.hybrid = true requires my.hardware.prime.intelBusId and my.hardware.prime.nvidiaBusId.";
      }
    ];

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      open = cfg.gpu.openDrivers;
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
        inherit (cfg.prime) intelBusId nvidiaBusId;
      };
    };

    hardware.graphics.extraPackages = with pkgs; [
      nvtopPackages.nvidia
    ];
  };
}
