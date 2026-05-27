{
  lib,
  config,
  pkgs,
  users,
  ...
}: let
  cfg = config.my.hardware.display;
in {
  config = lib.mkMerge [
    (lib.mkIf cfg.internalBacklight {
      environment.systemPackages = with pkgs; [
        brightnessctl
      ];
    })

    (lib.mkIf cfg.ddc {
      hardware.i2c.enable = true;

      boot.extraModulePackages = with config.boot.kernelPackages; [ddcci-driver];
      boot.kernelModules = lib.mkAfter ["i2c-dev" "ddcci" "ddcci-backlight"];

      environment.systemPackages = with pkgs; [
        ddcutil
        i2c-tools
      ];

      services.udev.extraRules = let
        bash = "${pkgs.bash}/bin/bash";
        ddcciDev = "AUX USBC4/DDI TC4/PHY TC4";
        ddcciNode = "/sys/bus/i2c/devices/i2c-17/new_device";
      in ''
        SUBSYSTEM=="i2c", ACTION=="add", ATTR{name}=="${ddcciDev}", RUN+="${bash} -c 'sleep 30; printf ddcci\ 0x37 > ${ddcciNode}'"
        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
      '';
    })
  ];
}
