{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.terminal.kitty;
  theme = config.my.features.theme;
in {
  options.my.features.terminal.kitty.enable = lib.mkEnableOption "Enable kitty terminal";

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };

    catppuccin.kitty.enable = theme.palette == "catppuccin";
  };
}
