{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.tui.btop;
  theme = config.my.features.theme;
in {
  options.my.features.desktop.apps.tui.btop.enable = lib.mkEnableOption "Enable btop TUI";

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        proc_sorting = "memory";
        theme_background = false;
      };
    };

    catppuccin.btop.enable = theme.palette == "catppuccin";
  };
}
