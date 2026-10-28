{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop.userDirectories;
in {
  config = lib.mkIf cfg.enable {
    home.file."${config.xdg.userDirs.pictures}/Wallpapers" = {
      source = ../../../assets/wallpapers;
      recursive = true;
    };
  };
}
