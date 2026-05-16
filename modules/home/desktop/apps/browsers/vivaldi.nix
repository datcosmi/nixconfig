{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.browsers.vivaldi;
in {
  options.my.features.desktop.apps.browsers.vivaldi.enable = lib.mkEnableOption "Enable vivaldi app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vivaldi
    ];
  };
}
