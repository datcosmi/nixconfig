{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.tui.bluetui;
  bluetooth = osConfig.my.features.system.services.bluetooth;
in {
  options.my.features.desktop.apps.tui.bluetui.enable = lib.mkEnableOption "Enable bluetui TUI";

  config = lib.mkIf (bluetooth.enable && cfg.enable) {
    home.packages = with pkgs; [
      bluetui
    ];
  };
}
