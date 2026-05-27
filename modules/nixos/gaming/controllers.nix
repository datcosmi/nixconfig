{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.features.gaming.controllers;
  hw = config.my.hardware;
in {
  config = mkIf cfg.enable {
    # Xbox controllers
    hardware.xone.enable = mkIf cfg.xbox true;
    hardware.xpadneo.enable = mkIf cfg.xbox true;

    # PlayStation DS4 / DualSense (DS5)

    boot.extraModprobeConfig = mkIf cfg.playstation ''
      # hid-sony: enable DS4 "Enhanced mode" for full touchpad, rumble and
      # battery reporting.  The parameter is available from kernel 5.16+.
      options hid_sony enhanced_rumble=1
    '';

    # Udev rules so DS4/DS5 devices are accessible without root.
    services.udev.extraRules = mkMerge [
      (mkIf cfg.playstation ''
        # ── DualShock 4 (DS4) ────────────────────────────────────────────
        # USB (Sony vendor 054c)
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", \
          MODE="0660", TAG+="uaccess", GROUP="input"
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", \
          MODE="0660", TAG+="uaccess", GROUP="input"
        # Bluetooth
        KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0660", TAG+="uaccess", GROUP="input"
        KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0660", TAG+="uaccess", GROUP="input"

        # ── DualSense (DS5) ───────────────────────────────────────────────
        # USB
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", \
          MODE="0660", TAG+="uaccess", GROUP="input"
        # Bluetooth
        KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess", GROUP="input"

        # ── DualSense Edge (DS5 pro) ──────────────────────────────────────
        KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0df2", \
          MODE="0660", TAG+="uaccess", GROUP="input"
        KERNEL=="hidraw*", KERNELS=="*054C:0DF2*", MODE="0660", TAG+="uaccess", GROUP="input"
      '')

      (mkIf cfg.xbox ''
        # ── Xbox Wireless Adapter (USB dongle / xone) ─────────────────────
        # Dongle device (045e:02fe is the dongle itself)
        KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02fe", \
          MODE="0660", TAG+="uaccess", GROUP="input"
        # ── Xbox One / Series controllers (USB) ───────────────────────────
        KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02d1", \
          MODE="0660", TAG+="uaccess", GROUP="input"
        KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02dd", \
          MODE="0660", TAG+="uaccess", GROUP="input"
        KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02e3", \
          MODE="0660", TAG+="uaccess", GROUP="input"
        KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02ea", \
          MODE="0660", TAG+="uaccess", GROUP="input"
        KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b00", \
          MODE="0660", TAG+="uaccess", GROUP="input"
        KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b0a", \
          MODE="0660", TAG+="uaccess", GROUP="input"
        KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b12", \
          MODE="0660", TAG+="uaccess", GROUP="input"
      '')
    ];

    # Steam hardware udev rules

    hardware.steam-hardware.enable = true;

    users.groups.input = {};

    # Packages

    environment.systemPackages = with pkgs; [
      # joystick calibration / testing tool
      jstest-gtk
      # evdev event viewer (diagnose button mappings)
      evtest
      # Antimicrox: map gamepad buttons to keyboard/mouse actions
      antimicrox
    ];
  };
}
