{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.bluetooth;
in {
  options.my.features.system.bluetooth.enable = lib.mkEnableOption "Bluetooth service";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings.General.Experimental = true;
    };
  };
}
