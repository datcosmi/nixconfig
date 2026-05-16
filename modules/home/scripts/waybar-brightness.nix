{pkgs, ...}: let
  brightnessCtl = pkgs.writeShellScriptBin "waybar-brightness" ''
    BUS1=2
    BUS2=4
    STEP=5

    get_brightness() {
      ${pkgs.ddcutil}/bin/ddcutil --bus="$1" getvcp 10 2>/dev/null \
        | grep -oP 'current value\s*=\s*\K[0-9]+'
    }

    set_brightness() {
      local val=$(( $1 < 0 ? 0 : $1 > 100 ? 100 : $1 ))
      ${pkgs.ddcutil}/bin/ddcutil --bus="$BUS1" setvcp 10 "$val" &
      ${pkgs.ddcutil}/bin/ddcutil --bus="$BUS2" setvcp 10 "$val" &
      wait
    }

    case "$1" in
      up)
        cur=$(get_brightness "$BUS1")
        set_brightness $(( cur + STEP ))
        ;;
      down)
        cur=$(get_brightness "$BUS1")
        set_brightness $(( cur - STEP ))
        ;;
      set)
        set_brightness "$2"
        ;;
      *)
        cur=$(get_brightness "$BUS1")
        cur=''${cur:-"?"}
        printf '{"text": "󰃠 ", "tooltip": "G24F / GS25F2: %s%%"}\n' "$cur" "$cur"
        ;;
    esac
  '';
in {
  home.packages = [brightnessCtl];
}
