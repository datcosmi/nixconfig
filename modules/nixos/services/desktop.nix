{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop;
in {
  config = lib.mkIf cfg.enable {
    services.gvfs.enable = true;
    services.tumbler.enable = true;
    services.udisks2.enable = true;
  };
}
