{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.networking.ipv6;
in {
  options.my.features.system.networking.ipv6.enable = lib.mkEnableOption "Ipv6 service";

  config = lib.mkIf cfg.enable {
    networking.enableIPv6 = true;

    boot.kernel.sysctl = {
      "net.ipv6.conf.all.disable_ipv6" = 0;
      "net.ipv6.conf.default.disable_ipv6" = 0;
    };
  };
}
