{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.launchers.rofi;
  emoji = config.my.features.desktop.fonts.emoji;
in {
  options.my.features.desktop.launchers.rofi.enable = lib.mkEnableOption "Use rofi launcher";

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf emoji.enable (with pkgs; [
      rofimoji
    ]);

    programs.rofi = {
      enable = true;
      plugins = [
        pkgs.rofi-calc
      ];

      extraConfig = {
        modi = "drun,run,filebrowser,window";
        show-icons = true;
        display-drun = "APPS";
        display-run = "RUN";
        display-filebrowser = "FILES";
        display-window = "WINDOW";
        drun-display-format = "{name}";
        window-format = "{w} · {c} · {t}";
        icon-theme = "Papirus";
      };
    };
  };
}
