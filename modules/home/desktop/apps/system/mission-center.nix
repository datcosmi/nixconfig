{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.system.mission-center;
in {
  options.my.features.desktop.apps.system.mission-center.enable = lib.mkEnableOption "Enable mission-center monitoring app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      mission-center
    ];
  };
}
