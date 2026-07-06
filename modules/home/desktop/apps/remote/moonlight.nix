{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.remote.moonlight;
in {
  options.my.features.desktop.apps.remote.moonlight.enable = lib.mkEnableOption "Enable Moonlight client";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      moonlight-qt
    ];
  };
}
