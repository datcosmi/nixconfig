{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.productivity.libreoffice;
in {
  options.my.features.desktop.apps.productivity.libreoffice.enable = lib.mkEnableOption "Enable LibreOffice suite";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice-still
    ];
  };
}
