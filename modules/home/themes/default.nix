{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop.userDirectories;
in
  with lib; {
    options.my.features.theme = {
      palette = mkOption {
        type = types.nullOr (types.enum ["catppuccin-mocha"]);
        default = null;
      };

      gtk = mkOption {
        type = types.nullOr (types.enum ["adwaita"]);
        default = null;
      };

      cursor = mkOption {
        type = types.nullOr (types.enum ["bibata-classic" "bibata-ice" "nordzy"]);
        default = null;
      };

      wallpaper = mkOption {
        type = types.path;
      };

      rofi-bg = mkOption {
        type = types.path;
      };

      colors = mkOption {
        type = types.attrsOf types.str;
        default = {};
      };
    };

    config = mkIf cfg.enable {
      home.file."${config.xdg.userDirs.pictures}/Wallpapers" = {
        source = ./wallpapers;
        recursive = true;
      };
    };

    imports = [
      ./palettes
      ./gtk
      ./cursor
    ];
  }
