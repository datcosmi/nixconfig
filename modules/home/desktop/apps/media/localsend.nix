{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.media.localsend;
in {
  options.my.features.desktop.apps.media.localsend.enable = lib.mkEnableOption "Enable localsend app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      localsend
    ];
  };
}
