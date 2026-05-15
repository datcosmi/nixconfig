{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = osConfig.my.features.wayland;
in {
  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      NIXOS_OZONE_WL = "1";
    };
  };
}
