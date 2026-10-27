{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.file-managers.nautilus;
  theme = config.my.features.theme;
in {
  options.my.features.desktop.apps.file-managers.nautilus.enable = lib.mkEnableOption "Enable nautilus File Manager";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        nautilus

        # Extensions
        sushi
      ];

      xdg.configFile."gtk-3.0/bookmarks".text = ''
        file://${config.home.homeDirectory}/Downloads Downloads
        file://${config.home.homeDirectory}/Documents Documents
        file://${config.home.homeDirectory}/Projects Projects
        file://${config.home.homeDirectory}/Pictures Pictures
        file://${config.home.homeDirectory}/Videos Videos
      '';
    })

    (lib.mkIf (cfg.enable && theme.gtk == "adwaita") {
      dconf.settings = {
        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "icon-view";
          show-hidden-files = false;
        };
        "org/gnome/nautilus/icon-view" = {
          default-zoom-level = "medium";
        };
      };
    })
  ];
}
