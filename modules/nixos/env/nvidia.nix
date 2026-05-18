{
  config,
  lib,
  ...
}: let
  cfg = config.my.hardware.gpu.vendor;
in {
  config = lib.mkIf (cfg == "nvidia") {
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
