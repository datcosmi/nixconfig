{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop.userDirectories;
in {
  imports = [
    ./palettes
    ./gtk
    ./cursor
  ];

  config = lib.mkIf cfg.enable {
    home.file."${config.xdg.userDirs.pictures}/Wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
  };
}
