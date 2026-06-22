{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.system;
in {
  options.my.features.desktop.apps.system.enable = lib.mkEnableOption "Enable all system related apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.system = {
      mission-center.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./mission-center.nix
  ];
}
