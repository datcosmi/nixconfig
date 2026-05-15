{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.terminal.ghostty;
in {
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;

      settings = {
        font-family = "JetBrainsMono Nerd Font";
        font-size = 11;
        background-opacity = 0.73;
        gtk-titlebar = false;
        confirm-close-surface = false;
        window-padding-x = 13;
        window-padding-y = 13;
        mouse-scroll-multiplier = 1.0;
      };
    };
  };
}
