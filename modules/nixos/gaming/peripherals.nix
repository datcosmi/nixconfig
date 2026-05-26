{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming.peripherals;
in {
  options.my.features.gaming.peripherals.enable = lib.mkEnableOption "Controller and peripheral support (Steam hardware, Xbox One, DualSense)";

  config = lib.mkIf cfg.enable {
    hardware.steam-hardware.enable = true;
    hardware.xone.enable = true;

    environment.systemPackages = with pkgs; [
      dualsensectl
    ];
  };
}
