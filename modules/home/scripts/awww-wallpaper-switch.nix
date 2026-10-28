{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = config.my.features.desktop.wallpaper.awww;
  wayland = osConfig.my.features.wayland;

  wallpaper = config.my.features.theme.wallpaper;
  awww-wallpaper = pkgs.writeShellScriptBin "awww-wallpaper" ''
    awww img ${wallpaper} --transition-type grow --transition-duration 1.2 --transition-fps 60
  '';
in {
  config = lib.mkIf (wayland.enable && cfg.enable) {
    home.packages = [awww-wallpaper];
  };
}
