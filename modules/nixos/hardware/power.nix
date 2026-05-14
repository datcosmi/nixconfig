{
  config,
  lib,
  ...
}: let
  cfg = config.my.hardware.hasBattery;
in {
  options.my.hardware.hasBattery = lib.mkEnableOption "Battery/power management";

  config = lib.mkIf cfg {
    services.upower.enable = true;
    powerManagement.enable = true;
  };
}
