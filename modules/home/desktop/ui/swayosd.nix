{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.ui.swayosd;
  wayland = osConfig.my.features.wayland;
in {
  options.my.features.desktop.ui.swayosd.enable = lib.mkEnableOption "Enable swayosd tool";

  config = lib.mkIf (wayland.enable && cfg.enable) {
    services.swayosd.enable = true;
  };
}
