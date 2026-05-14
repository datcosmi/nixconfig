{lib, ...}: let
  cfg = config.my.features.system.services.core;
in {
  options.my.features.system.services.core.enable = lib.mkEnableOption "Core system services";

  config = lib.mkIf cfg.enable {
    services.dbus = {
      enable = true;
      implementation = "broker";
    };
    security.polkit.enable = true;
    programs.dconf.enable = true;
  };
}
