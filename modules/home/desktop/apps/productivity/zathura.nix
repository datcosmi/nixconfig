{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.productivity.zathura;
  theme = config.my.features.theme;
in {
  options.my.features.desktop.apps.productivity.zathura.enable = lib.mkEnableOption "Enable Zathura app";

  config = lib.mkIf cfg.enable {
    programs.zathura.enable = true;

    catppuccin.zathura = lib.mkIf (theme == "catppuccin-mocha") {
      enable = true;
      flavor = "mocha";
    };
  };
}
