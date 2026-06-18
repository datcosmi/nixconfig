{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.networking.avahi;
in {
  options.my.features.system.networking.avahi.enable = lib.mkEnableOption "Avahi service";

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      ipv4 = true;
      ipv6 = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;

      publish = {
        enable = true;
        domain = true;
        addresses = true;
        userServices = true;
      };
    };
  };
}
