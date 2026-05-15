{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.music.tidal;
in {
  options.my.features.music.tidal.enable = lib.mkEnableOption "Enable tidal app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tidal-hifi
    ];
  };
}
