{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.ui.waybar;
  wayland = osConfig.my.features.wayland;
in {
  options.my.features.desktop.ui.waybar.enable = lib.mkEnableOption "Enable waybar tool";

  config = lib.mkIf (wayland.enable && cfg.enable) {
    programs.waybar.enable = true;
  };
}
