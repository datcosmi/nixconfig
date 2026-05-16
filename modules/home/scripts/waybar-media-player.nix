{ pkgs, ... }:

let
  waybar-media-player = pkgs.writeShellApplication {
    name = "waybar-media-player";
    runtimeInputs = [
      (pkgs.python3.withPackages (ps: [ ps.pygobject3 ]))
      pkgs.playerctl
      pkgs.gobject-introspection
    ];
    text = ''
      export GI_TYPELIB_PATH="${pkgs.playerctl}/lib/girepository-1.0"
      python3 ${./media-player.py} "$@"
    '';
  };
in
{
  home.packages = [ 
    waybar-media-player
    pkgs.playerctl
  ];
}
