{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop;
in {
  imports = [
    ./apps
    ./wm
  ];

  options.my.features.desktop.enable = lib.mkEnableOption "Desktop stack";

  config = lib.mkIf cfg.enable {
    my.features.desktop = {
      apps.enable = lib.mkDefault true;
    };
  };
}
