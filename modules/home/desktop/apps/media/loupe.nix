{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.media.loupe;
in {
  options.my.features.desktop.apps.media.loupe.enable = lib.mkEnableOption "Enable loupe app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      loupe
    ];
  };
}
