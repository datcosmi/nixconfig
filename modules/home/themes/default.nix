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
        type = types.enum ["catppuccin-mocha"];
        default = "catppuccin-mocha";
      };

      gtk = mkOption {
        type = types.enum ["adwaita"];
        default = "adwaita";
      };

      cursor = mkOption {
        type = types.enum ["bibata-classic" "bibata-ice" "nordzy"];
        default = "bibata-ice";
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
