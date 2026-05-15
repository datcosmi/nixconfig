{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.browsers.vivaldi;
in {
  options.my.features.browsers.vivaldi.enable = lib.mkEnableOption "Enable vivaldi app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      vivaldi
    ];
  };
}
