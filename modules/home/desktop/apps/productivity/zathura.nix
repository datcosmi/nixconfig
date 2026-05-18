{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.productivity.zathura;
in {
  options.my.features.desktop.apps.productivity.zathura.enable = lib.mkEnableOption "Enable Zathura app";

  config = lib.mkIf cfg.enable {
    programs.zathura.enable = true;
  };
}
