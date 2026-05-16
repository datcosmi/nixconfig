{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.networking.networkManager;
  wifi = config.my.hardware.hasWifi;
in {
  options.my.features.system.networking.networkManager.enable = lib.mkEnableOption "NetworkManager service";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      networking.networkmanager = {
        enable = true;
      };

      systemd.services.NetworkManager-wait-online.enable = false;

      environment.systemPackages = with pkgs; [
        networkmanagerapplet
      ];
    })

    (lib.mkIf wifi {
      networking.wireless.iwd.enable = true;
      networking.networkmanager.wifi.backend = "iwd";
    })
  ];
}
