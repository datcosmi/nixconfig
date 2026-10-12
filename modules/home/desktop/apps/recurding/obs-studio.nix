{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.recording.obs-studio;
in {
  options.my.features.desktop.apps.recording.obs-studio.enable = lib.mkEnableOption "Enable obs-studio";

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
    };
  };
}
