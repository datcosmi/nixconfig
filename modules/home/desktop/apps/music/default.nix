{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.music;
in {
  imports = [
    ./spotify.nix
    ./tidal.nix
  ];

  options.my.features.music.enable = lib.mkEnableOption "Enable music apps";

  config = lib.mkIf cfg.enable {
    my.features.music = {
      spotify.enable = lib.mkDefault true;
      tidal.enable = lib.mkDefault true;
    };
  };
}
