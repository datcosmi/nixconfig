{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.services.security.gnomeKeyring;
  greeter = config.my.features.system.login;
in {
  options.my.features.system.services.security.gnomeKeyring.enable = lib.mkEnableOption "GNOME keyring service";

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    security.pam.services = {
      greetd.enableGnomeKeyring = greeter.tuigreet.enable;
      sddm.enableGnomeKeyring = greeter.sddm.enable;
      login.enableGnomeKeyring = true;
    };
  };
}
