{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.music;
in {
  imports = [
    ./spotify.nix
    ./tidal.nix
    ./sidra.nix
  ];

  options.my.features.desktop.apps.music.enable = lib.mkEnableOption "Enable music apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.music = {
      spotify.enable = lib.mkDefault true;
      tidal.enable = lib.mkDefault true;
      sidra.enable = lib.mkDefault true;
    };
  };
}
