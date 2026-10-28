{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.theme;
in {
  config = lib.mkIf (cfg.palette == "catppuccin") {
    catppuccin = {
      enable = true;
      autoEnable = false;
      cache.enable = true;

      flavor = cfg.catppuccin.flavor;
      accent = cfg.catppuccin.accent;
    };
  };
}
