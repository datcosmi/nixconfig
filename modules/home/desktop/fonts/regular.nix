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
      noto-fonts
    ];
  };
}
