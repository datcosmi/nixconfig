{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.music.tidal;
in {
  options.my.features.desktop.apps.music.tidal.enable = lib.mkEnableOption "Enable tidal app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tidal-hifi
    ];
  };
}
