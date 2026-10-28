{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.eza;
  theme = config.my.features.theme;
in {
  options.my.features.shell.eza.enable = lib.mkEnableOption "Enable eza shell tool";

  config = lib.mkIf cfg.enable {
    programs.eza.enable = true;

    catppuccin.eza.enable = theme.palette == "catppuccin";
  };
}
