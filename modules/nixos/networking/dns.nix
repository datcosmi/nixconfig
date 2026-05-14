{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.networking.dns;
in {
  options.my.features.system.networking.dns.enable = lib.mkEnableOption "Dns service";

  config = lib.mkIf cfg.enable {
    services.resolved = {
      enable = true;

      settings = {
        Resolve = {
          DNSSEC = "false";
          Domains = ["~."];
          FallbackDNS = [
            "9.9.9.11"
            "149.112.112.11"
          ];
        };
      };
    };

    # networking.nameservers = ["127.0.0.53"];
  };
}
