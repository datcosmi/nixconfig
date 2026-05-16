{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.my.features.desktop.wallpaper.awww;
in {
  options.my.features.desktop.wallpaper.awww.enable = lib.mkEnableOption "Enable awww tool for wallpapers on wayland";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    ];
  };
}
