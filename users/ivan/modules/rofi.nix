{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.launchers.rofi;
in {
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      font = "JetBrains Mono Nerd Font 12";

      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          bg0 = mkLiteral "#1E1E2EB3";
          bg1 = mkLiteral "#313244";
          bg2 = mkLiteral "#45475A80";
          bg3 = mkLiteral "#F5C2E7F2";
          fg0 = mkLiteral "#CDD6F4";
          fg1 = mkLiteral "#CDD6F4";
          fg2 = mkLiteral "#BAC2DE";
          fg3 = mkLiteral "#6C7086";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg0";
          margin = mkLiteral "0px";
          padding = mkLiteral "0px";
          spacing = mkLiteral "0px";
        };

        window = {
          location = mkLiteral "north";
          y-offset = mkLiteral "calc(50% - 176px)";
          width = mkLiteral "480px";
          border-radius = mkLiteral "24px";
          background-color = mkLiteral "@bg0";
        };

        mainbox = {
          padding = mkLiteral "12px";
        };

        inputbar = {
          background-color = mkLiteral "@bg1";
          border-color = mkLiteral "@bg3";
          border = mkLiteral "2px";
          border-radius = mkLiteral "16px";
          padding = mkLiteral "8px 16px";
          spacing = mkLiteral "8px";
          children = map mkLiteral ["prompt" "entry"];
        };

        prompt = {
          text-color = mkLiteral "@fg2";
        };

        entry = {
          placeholder = "Search";
          placeholder-color = mkLiteral "@fg3";
        };

        message = {
          margin = mkLiteral "12px 0 0";
          border-radius = mkLiteral "16px";
          border-color = mkLiteral "@bg2";
          background-color = mkLiteral "@bg2";
        };

        textbox = {
          padding = mkLiteral "8px 24px";
        };

        listview = {
          background-color = mkLiteral "transparent";
          margin = mkLiteral "12px 0 0";
          lines = 8;
          columns = 1;
          fixed-height = false;
        };

        element = {
          padding = mkLiteral "8px 16px";
          spacing = mkLiteral "8px";
          border-radius = mkLiteral "16px";
        };

        "element selected normal" = {
          background-color = mkLiteral "@bg3";
        };

        "element selected active" = {
          background-color = mkLiteral "@bg3";
        };

        "element selected" = {
          text-color = mkLiteral "@bg1";
        };

        "element normal active" = {
          text-color = mkLiteral "@bg3";
        };

        "element alternate active" = {
          text-color = mkLiteral "@bg3";
        };

        element-icon = {
          size = mkLiteral "1em";
          vertical-align = mkLiteral "0.5";
        };

        element-text = {
          text-color = mkLiteral "inherit";
        };
      };
    };
  };
}
