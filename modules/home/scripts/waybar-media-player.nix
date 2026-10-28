{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  cfg = config.my.features.desktop.ui.waybar;
  wayland = osConfig.my.features.wayland;

  waybar-media-player = pkgs.writeShellApplication {
    name = "waybar-media-player";
    runtimeInputs = [
      (pkgs.python3.withPackages (ps: [ps.pygobject3]))
      pkgs.playerctl
      pkgs.gobject-introspection
    ];
    text = ''
      export GI_TYPELIB_PATH="${pkgs.playerctl}/lib/girepository-1.0"
      python3 ${./waybar-media-player.py} "$@"
    '';
  };
in {
  config = lib.mkIf (wayland.enable && cfg.enable) {
    home.packages = [
      waybar-media-player
      pkgs.playerctl
    ];
  };
}
