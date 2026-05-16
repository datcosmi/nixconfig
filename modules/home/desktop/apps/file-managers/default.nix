{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.file-managers;
in {
  options.my.features.desktop.apps.file-managers.enable = lib.mkEnableOption "Enable all File Manager apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.file-managers = {
      nautilus.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./nautilus.nix
  ];
}
