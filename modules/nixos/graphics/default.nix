{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.niri;
  hw = config.my.hardware;
in {
  config = lib.mkMerge [
    {
      services.xserver.enable = true;

      hardware.graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = lib.optionals hw.hybrid [pkgs.intel-media-driver];
      };

      environment.systemPackages = with pkgs; [
        vulkan-tools # vulkaninfo, vkcube
        libva-utils # vainfo
      ];
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
