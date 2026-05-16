{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.media.vlc;
in {
  options.my.features.desktop.apps.media.vlc.enable = lib.mkEnableOption "Enable vlc app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
