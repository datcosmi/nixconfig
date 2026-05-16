{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps;
in {
  options.my.features.desktop.apps.enable = lib.mkEnableOption "Enable all desktop apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps = {
      music.enable = lib.mkDefault true;
      browsers.enable = lib.mkDefault true;
      file-managers.enable = lib.mkDefault true;
      communication.enable = lib.mkDefault true;
      media.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./music
    ./browsers
    ./file-managers
    ./communication
    ./media
  ];
}
