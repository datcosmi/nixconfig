{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.theme;
  gtkTheme =
    if cfg.dark
    then "adw-gtk3-dark"
    else "adw-gtk3";
  colorScheme =
    if cfg.dark
    then "prefer-dark"
    else "prefer-light";
in
  with lib; {
    options.my.features.theme.dark = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use dark mode.";
    };

    config = mkIf (cfg.gtk == "adwaita") {
      my.features.theme.cursor = lib.mkDefault (
        if cfg.dark
        then "bibata-classic"
        else "bibata-ice"
      );

      gtk = {
        enable = true;

        theme = {
          name = gtkTheme;
          package = pkgs.adw-gtk3;
        };

        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = cfg.dark;
        };

        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = cfg.dark;
        };
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = colorScheme;
          gtk-theme = gtkTheme;
          icon-theme = "Adwaita";
          font-name = "Cantarell 11";
          document-font-name = "Cantarell 11";
          monospace-font-name = "Source Code Pro 10";
          font-antialiasing = "rgba";
          font-hinting = "slight";
          text-scaling-factor = 1.0;
        };

        "org/gtk/settings/file-chooser" = {
          show-hidden = false;
          sort-directories-first = true;
        };
      };

      services.xsettingsd = {
        enable = true;
        settings = {
          "Net/ThemeName" = gtkTheme;
          "Net/IconThemeName" = "Adwaita";
          "Xft/Antialias" = 1;
          "Xft/Hinting" = 1;
          "Xft/HintStyle" = "hintslight";
          "Xft/RGBA" = "rgb";
          "Gtk/FontName" = "Cantarell 11";
        };
      };

      home.sessionVariables.GTK_THEME = gtkTheme;

      home.packages = with pkgs; [
        cantarell-fonts
        source-code-pro
      ];
    };
  }
