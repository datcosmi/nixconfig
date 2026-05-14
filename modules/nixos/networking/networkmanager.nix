{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.networking.networkManager;
in {
  options.my.features.system.networking.networkManager.enable = lib.mkEnableOption "NetworkManager service";

  config = lib.mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
    };

    systemd.services.NetworkManager-wait-online.enable = false;

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
