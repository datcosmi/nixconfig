{
  config,
  lib,
  ...
}: let
  cfg = config.my.hardware;
in {
  config = lib.mkIf (cfg.gpu == "nvidia") {
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
