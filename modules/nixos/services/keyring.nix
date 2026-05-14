{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.security.gnomeKeyring;
in {
  options.my.features.system.security.gnomeKeyring.enable = lib.mkEnableOption "GNOME keyring service";

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    services.dbus.packages = [
      pkgs.gnome-keyring
      pkgs.gcr
      pkgs.dconf
    ];

    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
    };
  };
}
