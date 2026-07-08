{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.theme;
in {
  config = lib.mkIf (cfg.palette == "catppuccin-mocha") {
    catppuccin = {
      enable = true;
      autoEnable = false;
      cache.enable = true;
    };
  };
}
