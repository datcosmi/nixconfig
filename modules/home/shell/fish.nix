{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.fish;
  theme = config.my.features.theme;
in {
  options.my.features.shell.fish.enable = lib.mkEnableOption "Enable fish shell";

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;

      shellInit = ''
        set -g fish_greeting
      '';
    };

    programs.dircolors.enableFishIntegration = true;

    catppuccin.fish.enable = theme.palette == "catppuccin";
  };
}
