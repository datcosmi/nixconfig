{
  lib,
  config,
  pkgs,
  users,
  ...
}: let
  cfg = config.my.hardware.display;
  userNames = lib.attrNames users;

  i2cUsers = lib.genAttrs userNames (_: {
    extraGroups = lib.mkAfter ["i2c"];
  });
in {
  config = lib.mkMerge [
    (lib.mkIf cfg.internalBacklight {
      environment.systemPackages = with pkgs; [
        brightnessctl
      ];
    })

    (lib.mkIf cfg.ddc {
      hardware.i2c.enable = true;

      boot.kernelModules = lib.mkAfter ["i2c-dev"];

      environment.systemPackages = with pkgs; [
        ddcutil
        i2c-tools
      ];

      users.users = i2cUsers;

      services.udev.extraRules = ''
        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
      '';
    })
  ];
}
