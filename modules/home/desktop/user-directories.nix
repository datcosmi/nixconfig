{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.userDirectories;
in {
  options.my.features.desktop.userDirectories.enable = lib.mkEnableOption "Enable user directories";

  config = lib.mkIf cfg.enable {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
