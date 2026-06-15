{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.networking;
in {
  imports = [
    ./networkmanager.nix
    ./dns.nix
    ./avahi.nix
    ./firewall.nix
    ./ipv6.nix
  ];

  options.my.features.system.networking.enable = lib.mkEnableOption "Networking services";

  config = lib.mkIf cfg.enable {
    my.features.system.networking = {
      dns.enable = lib.mkDefault true;
      firewall.enable = lib.mkDefault true;
      avahi.enable = lib.mkDefault true;
      ipv6.enable = lib.mkDefault true;
      networkManager.enable = lib.mkDefault true;
    };
  };
}
