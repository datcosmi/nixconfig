{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.tui.wiremix;
  audio = osConfig.my.features.system.services.audio;
in {
  options.my.features.desktop.apps.tui.wiremix.enable = lib.mkEnableOption "Enable wiremix TUI";

  config = lib.mkIf (audio.enable && cfg.enable) {
    home.packages = with pkgs; [
      wiremix
    ];
  };
}
