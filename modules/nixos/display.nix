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

      boot.kernelModules = lib.mkAfter ["i2c-dev"];

      environment.systemPackages = with pkgs; [
        ddcutil
        i2c-tools
      ];

      services.udev.extraRules = ''
        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
      '';
    })
  ];
}
