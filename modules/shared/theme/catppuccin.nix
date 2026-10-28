{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.my.features.theme;
  palette = lib.importJSON "${inputs.catppuccin-palette}/palette.json";
in {
  config = lib.mkIf (cfg.palette == "catppuccin") {
    my.features.theme = {
      colors = lib.mapAttrs (_: c: c.hex) palette.${cfg.catppuccin.flavor}.colors;
      wallpaper = lib.mkDefault ../../../assets/wallpapers/blue-landscape-cat.png;
      rofi-bg = lib.mkDefault ../../../assets/wallpapers/rofi-bg.jpg;
    };

    catppuccin = {
      enable = true;
      autoEnable = false;
      cache.enable = true;
      inherit (cfg.catppuccin) flavor accent;
    };
  };
}
