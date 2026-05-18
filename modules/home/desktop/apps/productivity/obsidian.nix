{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.productivity.obsidian;
in {
  options.my.features.desktop.apps.productivity.obsidian.enable = lib.mkEnableOption "Enable Obsidian app";

  config = lib.mkIf cfg.enable {
    programs.obsidian.enable = true;
  };
}
