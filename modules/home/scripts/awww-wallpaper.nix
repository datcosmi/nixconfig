{
  pkgs,
  config,
  ...
}: let
  wallpaper = config.my.theme.wallpaper;
  awww-wallpaper = pkgs.writeShellScriptBin "awww-wallpaper" ''
    awww img ${wallpaper} --transition-type grow --transition-duration 1.2 --transition-fps 60
  '';
in {
  home.packages = [awww-wallpaper];
}
