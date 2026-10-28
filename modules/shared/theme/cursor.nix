{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.theme;

  cursors = {
    bibata-classic = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 20;
    };
    bibata-ice = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 20;
    };
    nordzy = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
      size = 24;
    };
  };

  effective =
    if cfg.cursor != null
    then cfg.cursor
    else if cfg.gtk == "adwaita"
    then
      (
        if cfg.dark
        then "bibata-classic"
        else "bibata-ice"
      )
    else null;
in {
  config.my.features.theme.cursorSpec =
    if effective == null
    then null
    else cursors.${effective};
}
