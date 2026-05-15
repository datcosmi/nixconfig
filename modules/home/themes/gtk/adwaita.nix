{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.theme;
in
  with lib;
    mkIf (cfg.gtk == "adwaita")
    {
      gtk = {
        enable = true;

        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };

        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };

        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "adw-gtk3";
          icon-theme = "Adwaita";
          font-name = "Cantarell 11";
          document-font-name = "Cantarell 11";
          monospace-font-name = "Source Code Pro 10";
          font-antialiasing = "rgba";
          font-hinting = "slight";
          text-scaling-factor = 1.0;
        };

        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "icon-view";
          show-hidden-files = false;
        };
        "org/gnome/nautilus/icon-view" = {
          default-zoom-level = "medium";
        };
        "org/gtk/settings/file-chooser" = {
          show-hidden = false;
          sort-directories-first = true;
        };
      };

      services.xsettingsd = {
        enable = true;
        settings = {
          "Net/ThemeName" = "adw-gtk3";
          "Net/IconThemeName" = "Adwaita";
          "Xft/Antialias" = 1;
          "Xft/Hinting" = 1;
          "Xft/HintStyle" = "hintslight";
          "Xft/RGBA" = "rgb";
          "Gtk/FontName" = "Cantarell 11";
        };
      };

      home.sessionVariables.GTK_THEME = "adw-gtk3";

      home.packages = with pkgs; [
        cantarell-fonts
        source-code-pro
      ];
    }
