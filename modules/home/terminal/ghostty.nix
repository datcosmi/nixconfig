{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.terminal.ghostty;
  theme = config.my.features.theme;
in {
  options.my.features.terminal.ghostty.enable = lib.mkEnableOption "Enable ghostty terminal";

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;

      settings = {
        font-family = "JetBrainsMono Nerd Font";
        font-size = 11;
        background-opacity = 0.95;
        gtk-titlebar = false;
        confirm-close-surface = false;
        window-padding-x = 17;
        window-padding-y = 17;
        mouse-scroll-multiplier = 1.0;
      };
    };

    catppuccin.ghostty.enable = theme.palette == "catppuccin";
  };
}
