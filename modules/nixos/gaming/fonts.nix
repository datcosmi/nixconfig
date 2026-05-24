{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming.fonts;
in {
  options.my.features.gaming.fonts = {
    enable = lib.mkEnableOption "CJK and symbol fonts for game UI coverage";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      liberation_ttf
    ];
  };
}
