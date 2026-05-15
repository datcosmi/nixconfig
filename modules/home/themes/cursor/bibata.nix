{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.theme;
in {
  config = lib.mkMerge [
    (lib.mkIf (cfg.cursor == "bibata-classic") {
      home.pointerCursor = {
        gtk.enable = true;
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 20;
      };
    })

    (lib.mkIf (cfg.cursor == "bibata-ice") {
      home.pointerCursor = {
        gtk.enable = true;
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 20;
      };
    })
  ];
}
