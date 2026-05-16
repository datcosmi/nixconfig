{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.ui.swaync;
  wayland = osConfig.my.features.wayland;
in {
  options.my.features.desktop.ui.swaync.enable = lib.mkEnableOption "Enable swaync tool";

  config = lib.mkIf (wayland.enable && cfg.enable) {
    services.swaync.enable = true;
  };
}
