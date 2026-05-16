{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.tui.yazi;
in {
  options.my.features.desktop.apps.tui.yazi.enable = lib.mkEnableOption "Enable yazi TUI";

  config = lib.mkIf cfg.enable {
    programs.yazi.enable = true;
  };
}
