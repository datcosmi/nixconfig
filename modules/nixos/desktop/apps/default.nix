{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop.apps;
in {
  imports = [
    ./zen.nix
    ./gnome-disks.nix
  ];

  options.my.features.desktop.apps.enable = lib.mkEnableOption "Desktop applications";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.zen-browser.enable = lib.mkDefault true;
    my.features.desktop.apps.gnome-disks.enable = lib.mkDefault true;
  };
}
