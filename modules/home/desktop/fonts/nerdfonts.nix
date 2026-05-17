{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.fonts.nerd-fonts;
in {
  options.my.features.desktop.fonts.nerd-fonts.enable = lib.mkEnableOption "Enable Nerd Fonts";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.commit-mono
    ];
  };
}
