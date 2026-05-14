{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.services.flatpak;
in {
  options.my.features.system.services.flatpak.enable = lib.mkEnableOption "Flatpak service";

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
