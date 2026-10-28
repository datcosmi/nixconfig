{lib, ...}:
with lib; {
  options.my.features.theme = {
    palette = mkOption {
      type = types.nullOr (types.enum ["catppuccin"]);
      default = null;
    };

    catppuccin = {
      flavor = mkOption {
        type = types.enum ["latte" "frappe" "macchiato" "mocha"];
        default = "mocha";
      };
      accent = mkOption {
        type = types.enum [
          "rosewater"
          "flamingo"
          "pink"
          "mauve"
          "red"
          "maroon"
          "peach"
          "yellow"
          "green"
          "teal"
          "sky"
          "sapphire"
          "blue"
          "lavender"
        ];
        default = "pink";
      };
    };

    gtk = mkOption {
      type = types.nullOr (types.enum ["adwaita"]);
      default = null;
    };

    cursor = mkOption {
      type = types.nullOr (types.enum [
        "bibata-classic"
        "bibata-ice"
        "nordzy"
      ]);
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
}
