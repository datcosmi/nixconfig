{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.fonts.regular;
in {
  options.my.features.desktop.fonts.regular.enable = lib.mkEnableOption "Enable Regular Fonts";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-cjk-sans
      liberation_ttf
      dejavu_fonts
      lexend
      jetbrains-mono
    ];
  };
}
