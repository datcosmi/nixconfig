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
    };

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "${wallpaper}";
      };
    };
  };
}
