{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.services.security.gnomeKeyring;
in {
  options.my.features.system.services.security.gnomeKeyring.enable = lib.mkEnableOption "GNOME keyring service";

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    services.dbus.packages = [
      pkgs.gnome-keyring
      pkgs.gcr
      pkgs.dconf
    ];

    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      sddm.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
    };
  };
}
