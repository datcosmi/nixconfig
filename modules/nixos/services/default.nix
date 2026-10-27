{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.services;
in {
  options.my.features.system.services.enable = lib.mkEnableOption "System services";

  config = lib.mkIf cfg.enable {
    my.features.system = {
      services = {
        core.enable = lib.mkForce true;
        bluetooth.enable = lib.mkDefault true;
        audio.enable = lib.mkDefault true;
        flatpak.enable = lib.mkDefault true;
        appimage.enable = lib.mkDefault true;
        printing.enable = lib.mkDefault true;

        security = {
          gnomeKeyring.enable = lib.mkDefault true;
          polkitAgent.enable = lib.mkDefault true;
        };
      };
    };
  };
}
