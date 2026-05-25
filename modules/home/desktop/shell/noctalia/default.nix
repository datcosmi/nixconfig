{
  config,
  lib,
  osConfig,
  pkgs,
  inputs,
  ...
}: let
  cfg = osConfig.my.features.desktop.noctalia;
  wallpaper = config.my.features.theme.wallpaper;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          position = "left";
        };
        colorSchemes.predefinedScheme = "Catppuccin";
      };

      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];

        states = {
          network-manager-vpn = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };

        version = 2;
      };
    };

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "${wallpaper}";
      };
    };
  };
}
