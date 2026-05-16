{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "bluetooth-status" ''
      powered=$(${pkgs.bluez}/bin/bluetoothctl show | grep "Powered:" | awk '{print $2}')
      if [[ "$powered" != "yes" ]]; then
        echo '{"text":"󰂲","tooltip":"Bluetooth: Off","class":"off"}'
        exit 0
      fi
      connected_devices=$(${pkgs.bluez}/bin/bluetoothctl devices Connected | cut -d ' ' -f 3-)
      if [[ -n "$connected_devices" ]]; then
        tooltip="Connected:\n$connected_devices"
        echo "{\"text\":\"󰂱\",\"tooltip\":\"$tooltip\",\"class\":\"connected\"}"
      else
        echo '{"text":"󰂯","tooltip":"Bluetooth: On (no devices connected)","class":"on"}'
      fi
    '')
  ];
}
