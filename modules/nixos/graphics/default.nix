{
  pkgs,
  config,
  lib,
  ...
}: let
  host = config.my.hardware.host;
in {
  imports = [
    ./nvidia.nix
  ];

  services.xserver.enable = true;

  services.xserver.xkb =
    if host == "desktop"
    then {
      layout = "us";
      variant = "altgr-intl";
    }
    else {
      layout = "latam";
    };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  xdg.portal = {
    enable = true;
    # wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "gtk";
  };
}
