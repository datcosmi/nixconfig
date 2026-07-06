{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.services.sunshine;
in {
  options.my.features.system.services.sunshine.enable = lib.mkEnableOption "Enable Sunshine support";

  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    hardware.uinput.enable = true;
  };
}
