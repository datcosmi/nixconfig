{
  pkgs,
  config,
  lib,
  ...
}: let
  kbd = config.my.hardware.keyboard;
in {
  console.keyMap = kbd.keyMap;

  services.xserver.xkb = {
    layout = kbd.layout;
    variant = kbd.variant;
  };
}
