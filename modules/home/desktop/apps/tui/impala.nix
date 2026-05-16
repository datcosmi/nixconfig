{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.tui.impala;
  wifi = osConfig.my.hardware.hasWifi;
in {
  options.my.features.desktop.apps.tui.impala.enable = lib.mkEnableOption "Enable impala TUI";

  config = lib.mkIf (wifi && cfg.enable) {
    home.packages = with pkgs; [
      impala
    ];
  };
}
