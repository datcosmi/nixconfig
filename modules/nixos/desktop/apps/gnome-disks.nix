{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.gnome-disks;
in {
  options.my.features.desktop.apps.gnome-disks.enable = lib.mkEnableOption "Enable Gnome Disks GUI app";

  config = lib.mkIf cfg.enable {
    programs.gnome-disks.enable = true;
  };
}
