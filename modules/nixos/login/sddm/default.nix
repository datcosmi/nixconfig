{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.login.sddm;
  spec = config.my.features.theme.cursorSpec;
  wayland = config.my.features.wayland.enable;
in {
  options.my.features.system.login.sddm.enable = lib.mkEnableOption "Enable SDDM Display Manager";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.optional (spec != null) spec.package;

    services.displayManager.sddm = {
      enable = true;
      wayland = lib.mkIf wayland {enable = lib.mkForce true;};
      settings.Theme = lib.mkIf (spec != null) {
        CursorTheme = spec.name;
        CursorSize = spec.size;
      };
    };
  };
}
