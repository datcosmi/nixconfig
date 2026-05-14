{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.services.bluetooth;
in {
  options.my.features.system.services.bluetooth.enable = lib.mkEnableOption "Bluetooth service";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings.General.Experimental = true;
    };
  };
}
