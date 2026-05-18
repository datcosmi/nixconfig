{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.remote;
in {
  options.my.features.desktop.apps.remote.enable = lib.mkEnableOption "Enable all remote desktop apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.remote = {
      anydesk.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./anydesk.nix
  ];
}
