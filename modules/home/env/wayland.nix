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
      NIXOS_OZONE_WL = "1";
    };
  };
}
