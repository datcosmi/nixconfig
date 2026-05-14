{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.wayland;
in {
  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      # WLR_NO_HARDWARE_CURSORS = "1";
      # XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };
  };
}
