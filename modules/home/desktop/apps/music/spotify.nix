{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.music.spotify;
in {
  options.my.features.music.spotify.enable = lib.mkEnableOption "Enable spotify app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
    ];
  };
}
