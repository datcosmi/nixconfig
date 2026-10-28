{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.dev.git.lazygit;
  theme = config.my.features.theme;
in {
  options.my.features.dev.git.lazygit.enable = lib.mkEnableOption "Enable lazygit TUI";

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
    };

    catppuccin.lazygit.enable = theme.palette == "catppuccin";
  };
}
