{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.wayland;
in {
  imports = [
    ./niri
  ];

  options.my.features.wayland.enable = lib.mkEnableOption "Wayland session and related environment";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wl-mirror
    ];
  };
}
