{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.flatpak;
in {
  options.my.features.system.flatpak.enable = lib.mkEnableOption "Flatpak service";

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
