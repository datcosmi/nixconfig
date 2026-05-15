{
  pkgs,
  config,
  lib,
  ...
}: let
  kbd = config.my.hardware.keyboard;
  cfg = config.my.features.wayland;
in {
  imports = [./nvidia.nix];

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = kbd.layout;
    variant = kbd.variant;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config.common.default = "gtk";
    };
  };
}
