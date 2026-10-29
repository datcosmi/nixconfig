{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.bat;
  theme = config.my.features.theme;
in {
  options.my.features.shell.bat.enable = lib.mkEnableOption "Enable bat shell tool";

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;

      extraPackages = with pkgs.bat-extras; [
        batman
      ];
    };

    catppuccin.bat.enable = theme.palette == "catppuccin";
  };
}
