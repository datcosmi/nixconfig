{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.networking.firewall;
in {
  options.my.features.system.networking.firewall.enable = lib.mkEnableOption "Firewall service";

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      enable = true;

      allowPing = true;
      checkReversePath = "loose";

      trustedInterfaces = [
        "enp5s0" "wlan0"
      ];
    };
  };
}
