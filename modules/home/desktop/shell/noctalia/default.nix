{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.my.features.desktop.shell.noctalia;
  wallpaper = config.my.features.theme.wallpaper;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.my.features.desktop.shell.noctalia.enable = lib.mkEnableOption "Enable Noctalia Shell";

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
