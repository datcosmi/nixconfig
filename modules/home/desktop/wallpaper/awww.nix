{
  config,
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.my.features.desktop.wallpaper.awww;
  wayland = osConfig.my.features.wayland;
  system = pkgs.stdenv.hostPlatform.system;
in {
  options.my.features.desktop.wallpaper.awww.enable = lib.mkEnableOption "Enable awww tool for wallpapers on wayland";

  config = lib.mkIf (wayland.enable && cfg.enable) {
    home.packages = with pkgs; [
      inputs.awww.packages.${system}.awww
    ];
  };
}
