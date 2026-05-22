{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.communication.vesktop;
  theme = config.my.features.theme;
in {
  options.my.features.desktop.apps.communication.vesktop.enable = lib.mkEnableOption "Enable vesktop app";

  config = lib.mkIf cfg.enable {
    programs.vesktop = {
      enable = true;
    };

    catppuccin.vesktop = lib.mkIf (theme == "catppuccin-mocha") {
      enable = true;
      flavor = "mocha";
      accent = "pink";
    };
  };
}
