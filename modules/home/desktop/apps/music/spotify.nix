{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.music.spotify;
in {
  options.my.features.desktop.apps.music.spotify.enable = lib.mkEnableOption "Enable spotify app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
    ];
  };
}
