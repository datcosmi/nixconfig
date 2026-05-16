{
  config,
  lib,
  ...
}: let
  cfg = config.my.hardware.needSuspend;
in {
  options.my.hardware.needSuspend = lib.mkEnableOption "Battery/power management";

  config = lib.mkIf cfg {
    services.upower.enable = true;
    powerManagement.enable = true;
  };
}
