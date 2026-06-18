{
  config,
  lib,
  ...
}: let
  cfg = config.my.hardware;
in {
  options.my.hardware.needSuspend = lib.mkEnableOption "Enable services needed to suspend the system";
  options.my.hardware.hasBattery = lib.mkEnableOption "Battery/power management";

  config = lib.mkMerge [
    (lib.mkIf cfg.needSuspend {
      services.upower.enable = true;
      powerManagement.enable = true;
    })

    (lib.mkIf cfg.hasBattery {
      services.power-profiles-daemon.enable = true;

      services.logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "ignore";
        HandleLidSwitchDocked = "ignore";
      };
    })
  ];
}
