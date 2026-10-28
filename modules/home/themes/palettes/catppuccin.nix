{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.my.features.theme;
  palette = lib.importJSON "${inputs.catppuccin-palette}/palette.json";
in
  lib.mkIf (cfg.palette == "catppuccin") {
    my.features.theme.colors = lib.mapAttrs (_: color: color.hex) palette.${cfg.catppuccin.flavor}.colors;

    my.features.theme = {
      wallpaper = ../wallpapers/blue-landscape-cat.png;
      rofi-bg = ../wallpapers/rofi-bg.jpg;
    };

    catppuccin = {
      enable = true;
      autoEnable = false;
      cache.enable = true;

      flavor = cfg.catppuccin.flavor;
      accent = cfg.catppuccin.accent;
    };
  }
