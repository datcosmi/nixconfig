{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.fonts;
in {
  options.my.features.desktop.fonts.enable =
    lib.mkEnableOption "Desktop fonts";

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.commit-mono

      noto-fonts
      noto-fonts-color-emoji
    ];

    fonts.fontconfig.enable = true;
  };
}
