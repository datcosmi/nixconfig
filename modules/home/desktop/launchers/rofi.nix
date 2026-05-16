{
  config,
  lib,
  pkgs,
  ...
}: let
  wallpaper = config.my.theme.rofi-bg;
  cfg = config.my.features.desktop.launchers.rofi;
in {
  options.my.features.desktop.launchers.rofi.enable = lib.mkEnableOption "Use rofi launcher";
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      plugins = [
        pkgs.rofi-calc
        pkgs.rofimoji
      ];

      font = "JetBrains Mono Nerd Font 10";

      # Icon theme
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          background = mkLiteral "#11092D";
          background-alt = mkLiteral "#281657";
          foreground = mkLiteral "#FFFFFF";
          selected = mkLiteral "#DF5296";
          active = mkLiteral "#6E77FF";
          urgent = mkLiteral "#8E3596";
        };

        window = {
          transparency = "real";
          location = mkLiteral "center";
          anchor = mkLiteral "center";
          fullscreen = false;
          width = mkLiteral "1000px";
          x-offset = mkLiteral "0px";
          y-offset = mkLiteral "0px";
          enabled = true;
          border-radius = mkLiteral "15px";
          cursor = "default";
          background-color = mkLiteral "@background";
        };

        mainbox = {
          enabled = true;
          spacing = mkLiteral "0px";
          background-color = mkLiteral "transparent";
          orientation = mkLiteral "horizontal";
          children = map mkLiteral ["imagebox" "listbox"];
        };

        imagebox = {
          padding = mkLiteral "20px";
          background-color = mkLiteral "transparent";
          background-image = mkLiteral "url(\"${wallpaper}\", height)";
          orientation = mkLiteral "vertical";
          children = map mkLiteral ["inputbar" "dummy" "mode-switcher"];
        };

        listbox = {
          spacing = mkLiteral "20px";
          padding = mkLiteral "20px";
          background-color = mkLiteral "transparent";
          orientation = mkLiteral "vertical";
          children = map mkLiteral ["message" "listview"];
        };

        dummy = {
          background-color = mkLiteral "transparent";
        };

        inputbar = {
          enabled = true;
          spacing = mkLiteral "10px";
          padding = mkLiteral "15px";
          border-radius = mkLiteral "10px";
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
          children = map mkLiteral ["textbox-prompt-colon" "entry"];
        };

        "textbox-prompt-colon" = {
          enabled = true;
          expand = false;
          str = "";
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        entry = {
          enabled = true;
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "text";
          placeholder = "Search";
          placeholder-color = mkLiteral "inherit";
        };

        mode-switcher = {
          enabled = true;
          spacing = mkLiteral "20px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground";
        };

        button = {
          padding = mkLiteral "15px";
          border-radius = mkLiteral "10px";
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "pointer";
        };

        "button selected" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@foreground";
        };

        listview = {
          enabled = true;
          columns = 1;
          lines = 8;
          cycle = true;
          dynamic = true;
          scrollbar = false;
          layout = mkLiteral "vertical";
          reverse = false;
          fixed-height = true;
          fixed-columns = true;
          spacing = mkLiteral "10px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground";
          cursor = "default";
        };

        element = {
          enabled = true;
          spacing = mkLiteral "15px";
          padding = mkLiteral "8px";
          border-radius = mkLiteral "10px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground";
          cursor = mkLiteral "pointer";
        };

        "element normal.normal" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        "element normal.urgent" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@foreground";
        };

        "element normal.active" = {
          background-color = mkLiteral "@active";
          text-color = mkLiteral "@foreground";
        };

        "element selected.normal" = {
          background-color = mkLiteral "@selected";
          text-color = mkLiteral "@foreground";
        };

        "element selected.urgent" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@foreground";
        };

        "element selected.active" = {
          background-color = mkLiteral "@urgent";
          text-color = mkLiteral "@foreground";
        };

        element-icon = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          size = mkLiteral "32px";
          cursor = mkLiteral "inherit";
        };

        element-text = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          cursor = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };

        message = {
          background-color = mkLiteral "transparent";
        };

        textbox = {
          padding = mkLiteral "15px";
          border-radius = mkLiteral "10px";
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };

        error-message = {
          padding = mkLiteral "15px";
          border-radius = mkLiteral "20px";
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@foreground";
        };
      };

      extraConfig = {
        modi = "drun,run,filebrowser,window";
        show-icons = true;
        display-drun = "APPS";
        display-run = "RUN";
        display-filebrowser = "FILES";
        display-window = "WINDOW";
        drun-display-format = "{name}";
        window-format = "{w} · {c} · {t}";
        icon-theme = "Papirus";
      };
    };
  };
}
