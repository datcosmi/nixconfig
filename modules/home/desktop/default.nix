{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop;
in {
  options.my.features.desktop.enable = lib.mkEnableOption "Enable all desktop app, utilities, etc.";

  config = lib.mkIf cfg.enable {
    my.features.desktop = {
      apps.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./apps
    ./wm
    ./launchers
    ./clipboard
  ];
}
