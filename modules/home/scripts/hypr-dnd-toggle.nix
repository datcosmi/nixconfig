{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "hypr-dnd-toggle" ''
      handle() {
        event=$(echo "$1" | cut -d'>' -f1)
        data=$(echo "$1" | cut -d'>' -f3)

        case $event in
          fullscreen)
            if [ "$data" = "1" ]; then
              ${pkgs.swaynotificationcenter}/bin/swaync-client -dn
            else
              ${pkgs.swaynotificationcenter}/bin/swaync-client -df
            fi
            ;;
        esac
      }

      ${pkgs.socat}/bin/socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
        handle "$line"
      done
    '')
  ];
}
