{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.remote.anydesk;
in {
  options.my.features.desktop.apps.remote.anydesk.enable = lib.mkEnableOption "Enable AnyDesk app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      anydesk
    ];
  };
}
