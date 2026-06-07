{
  config,
  pkgs,
  lib,
  ...
}: let
  vpnBin = "${pkgs.proton-vpn-cli}/bin/protonvpn";

  favouriteServers = [
    {
      label = "US-TX#169  (Dallas — default)";
      server = "US-TX#169";
    }
    {
      label = "US-TX#196  (Dallas)";
      server = "US-TX#196";
    }
    {
      label = "US-UT#96   (Salt Lake City)";
      server = "US-UT#96";
    }
  ];

  favouriteEntries = lib.concatMapStrings (s: "  ${s.label}\n") favouriteServers;

  favouriteCaseArms =
    lib.concatMapStrings (s: ''
      *"${s.label}"*)
        ${vpnBin} connect "${s.server}" && \
          notify-send -i network-vpn "ProtonVPN" "Connected to ${s.server}"
        ;;
    '')
    favouriteServers;

  configSettings = [
    {
      key = "netshield";
      label = "NetShield filter";
      values = ["off" "malware" "malware-ads-trackers"];
    }
    {
      key = "kill-switch";
      label = "Kill Switch";
      values = ["off" "standard" "always-on"];
    }
    {
      key = "port-forwarding";
      label = "Port Forwarding";
      values = ["on" "off"];
    }
    {
      key = "vpn-accelerator";
      label = "VPN Accelerator";
      values = ["on" "off"];
    }
    {
      key = "ipv6";
      label = "IPv6";
      values = ["on" "off"];
    }
    {
      key = "moderate-nat";
      label = "Moderate NAT";
      values = ["on" "off"];
    }
    {
      key = "custom-dns";
      label = "Custom DNS";
      values = ["off" "on"];
    }
    {
      key = "anonymous-crash-reports";
      label = "Anonymous Crash Reports";
      values = ["off" "on"];
    }
  ];

  settingsMenuEntries = lib.concatMapStrings (s: "  ${s.label}\n") configSettings;

  settingsCaseArms =
    lib.concatMapStrings (s: let
      valuesList = lib.concatStringsSep "\n" s.values;
    in ''
      *"${s.label}"*)
        CURRENT=$(${vpnBin} config list 2>/dev/null \
          | awk '/^${s.key}[[:space:]]/ {print $NF}')
        VALUE=$(printf '${valuesList}\n' \
          | rofi -dmenu -p "${s.label} [current: $CURRENT]" -i)
        [ -n "$VALUE" ] && ${vpnBin} config set ${s.key} "$VALUE" && \
          notify-send -i preferences-system "ProtonVPN Config" \
            "${s.label} → $VALUE"
        ;;
    '')
    configSettings;

  protonvpnRofi = pkgs.writeShellScriptBin "protonvpn-rofi" ''
    #!/usr/bin/env bash
    set -euo pipefail

    VPN="${vpnBin}"

    is_connected() {
      $VPN status 2>/dev/null | grep -qi "^status:[[:space:]]*connected$"
    }

    build_main_menu() {
      is_connected && echo -e "󰖂  Disconnect"
      echo -e "󰦝  Connect"
      echo -e "󰒓  Settings"
      echo -e "󰋼  Status"
    }

    MAIN=$(build_main_menu | rofi -dmenu -p "ProtonVPN" -i)
    [ -z "$MAIN" ] && exit 0

    case "$MAIN" in

      *"Disconnect"*)
        $VPN disconnect
        notify-send -i network-vpn "ProtonVPN" "Disconnected"
        ;;

      *"Connect"*)
        CONNECT_MENU=$(echo -e \
          "  Fastest server\n${favouriteEntries}󰍉  Pick a country\n󰍉  Pick a server" \
          | rofi -dmenu -p "Connect to…" -i)
        [ -z "$CONNECT_MENU" ] && exit 0

        case "$CONNECT_MENU" in
          *"Fastest"*)
            $VPN connect
            notify-send -i network-vpn "ProtonVPN" "Connected to fastest server"
            ;;

          ${favouriteCaseArms}

          *"Pick a country"*)
            SELECTION=$($VPN countries list 2>/dev/null \
              | tail -n +3 \
              | rofi -dmenu -p "Select country" -i)
            [ -z "$SELECTION" ] && exit 0
            COUNTRY=$(echo "$SELECTION" | awk '{print $NF}')
            $VPN connect --country "$COUNTRY" \
            && notify-send -i network-vpn "ProtonVPN" "Connected → $COUNTRY" \
            || notify-send -i dialog-error "ProtonVPN" "Failed to connect to $COUNTRY"
            ;;

          *"Pick a server"*)
            SERVER=$($VPN servers 2>/dev/null \
              | tail -n +3 | awk '{print $1}' \
              | rofi -dmenu -p "Select server" -i)
            [ -z "$SERVER" ] && exit 0
            $VPN connect "$SERVER"
            notify-send -i network-vpn "ProtonVPN" "Connected → $SERVER"
            ;;
        esac
        ;;

      *"Settings"*)
        SETTING=$(echo -e "${settingsMenuEntries}" \
          | rofi -dmenu -p "⚙ ProtonVPN Settings" -i)
        [ -z "$SETTING" ] && exit 0

        case "$SETTING" in
          ${settingsCaseArms}
        esac
        ;;

      *"Status"*)
        STATUS_TEXT=$($VPN status 2>/dev/null || echo "Unable to get status")
        echo "$STATUS_TEXT" | rofi -dmenu -p "VPN Status" -no-custom -i
        ;;

    esac
  '';
in {
  home.packages = [
    protonvpnRofi
  ];

  systemd.user.services.protonvpn-autoconnect = {
    Unit = {
      Description = "ProtonVPN — auto-connect to US-TX#169";
      After = ["graphical-session.target" "network-online.target"];
      Wants = ["network-online.target"];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";

      ExecStart = pkgs.writeShellScript "protonvpn-boot-connect" ''
        ${vpnBin} connect "US-TX#169"
      '';

      ExecStop = pkgs.writeShellScript "protonvpn-boot-disconnect" ''
        ${vpnBin} disconnect || true
      '';

      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
