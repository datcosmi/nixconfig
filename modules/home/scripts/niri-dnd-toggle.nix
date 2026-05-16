{pkgs, ...}: let
  niri-dnd-toggle = pkgs.writeShellScriptBin "niri-dnd-toggle" ''
    check_fullscreen() {
      ${pkgs.niri}/bin/niri msg --json windows 2>/dev/null \
        | ${pkgs.jq}/bin/jq -e 'any(.[]; .is_focused == true and .is_fullscreen == true)' \
        > /dev/null 2>&1
    }

    last_state=""

    ${pkgs.niri}/bin/niri msg --json event-stream \
      | ${pkgs.jq}/bin/jq -c --unbuffered '
          select(
            has("WindowOpenedOrChanged") or
            has("WindowFocusChanged") or
            has("WindowClosed")
          )
        ' \
      | while read -r _event; do
          if check_fullscreen; then
            state="fullscreen"
          else
            state="normal"
          fi

          if [ "$state" != "$last_state" ]; then
            if [ "$state" = "fullscreen" ]; then
              ${pkgs.swaynotificationcenter}/bin/swaync-client -dn
            else
              ${pkgs.swaynotificationcenter}/bin/swaync-client -df
            fi
            last_state="$state"
          fi
        done
  '';
in {
  home.packages = [niri-dnd-toggle];

  systemd.user.services.niri-dnd-toggle = {
    Unit = {
      Description = "Auto-toggle swaync DND on fullscreen windows in Niri";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${niri-dnd-toggle}/bin/niri-dnd-toggle";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
