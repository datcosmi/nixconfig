{
  pkgs,
  config,
  lib,
  ...
}: let
  kbd = config.my.hardware.keyboard;
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

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "gtk";
  };
}
