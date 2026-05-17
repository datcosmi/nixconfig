{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.fonts.emoji;
in {
  options.my.features.desktop.fonts.emoji.enable = lib.mkEnableOption "Enable Emoji Fonts";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      noto-fonts-color-emoji
    ];
  };
}
