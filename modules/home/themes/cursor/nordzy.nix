{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.theme;
in
  with lib;
    mkIf (cfg.cursor == "nordzy") {
      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
        size = 24;
      };
    }
