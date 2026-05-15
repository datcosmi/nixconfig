{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.music;
in {
  options.my.features.music.enable = lib.mkEnableOption "Enable music apps";

  config = lib.mkIf cfg.enable {
    my.features.music = {
      spotify = lib.mkDefault true;
      tidal = lib.mkDefault true;
    };
  };
}
