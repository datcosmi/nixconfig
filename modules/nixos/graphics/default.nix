{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.my.features.wayland;
in {
  imports = [./nvidia.nix];

  config = lib.mkMerge [
    {
      services.xserver.enable = true;

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    }

    (lib.mkIf cfg.enable {
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
          pkgs.xdg-desktop-portal-gtk
        ];
        config.common = {
          default = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
          "org.freedesktop.impl.portal.RemoteDesktop" = "hyprland";
        };
      };
    })
  ];
}
