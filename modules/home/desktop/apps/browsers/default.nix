{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.browsers;
in {

  options.my.features.desktop.apps.browsers.enable = lib.mkEnableOption "Enable browser apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.browsers = {
      zen-browser.enable = lib.mkDefault true;
      librewolf.enable = lib.mkDefault true;
      vivaldi.enable = lib.mkDefault true;
    };
  };
}
