{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  cfg = osConfig.my.hardware.display;
  ddc = config.my.features.services.ddcBrightness;

  ddcBrightnessScript = pkgs.writeShellScriptBin "ddc-brightness" ''
    STEP=''${2:-${toString ddc.step}}

    mapfile -t MONITORS < <(${pkgs.ddcutil}/bin/ddcutil detect 2>/dev/null \
      | grep -oP 'Display \K[0-9]+')

    if [[ ''${#MONITORS[@]} -eq 0 ]]; then
      echo "No DDC monitors detected" >&2
      exit 1
    fi

    CURRENT=$(${pkgs.ddcutil}/bin/ddcutil --display "''${MONITORS[0]}" getvcp 10 2>/dev/null \
      | grep -oP 'current value =\s*\K[0-9]+')

    [[ -z "$CURRENT" ]] && exit 1

    if [[ "$1" == "up" ]]; then
      NEW=$(( CURRENT + STEP ))
    elif [[ "$1" == "down" ]]; then
      NEW=$(( CURRENT - STEP ))
    else
      echo "Usage: ddc-brightness [up|down] [step]" >&2
      exit 1
    fi

    (( NEW < 0 ))   && NEW=0
    (( NEW > 100 )) && NEW=100

    for DISP in "''${MONITORS[@]}"; do
      ${pkgs.ddcutil}/bin/ddcutil --display "$DISP" setvcp 10 "$NEW" &
    done
    wait

    ${pkgs.swayosd}/bin/swayosd-client \
      --custom-icon "display-brightness-symbolic" \
      --custom-progress "$(${pkgs.gawk}/bin/awk "BEGIN {printf \"%.2f\", $NEW / 100}")"
  '';
in {
  options.my.features.services.ddcBrightness = {
    enable = lib.mkEnableOption "DDC brightness control script";

    step = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "Default brightness step percentage";
    };
  };

  config = lib.mkIf cfg.ddc {
    home.packages = [ddcBrightnessScript];
  };
}
