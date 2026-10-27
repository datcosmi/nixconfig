{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.networking.firewall;
in {
  options.my.features.system.networking.firewall = {
    enable = lib.mkEnableOption "Firewall service";
    backend = lib.mkOption {
      type = lib.types.enum ["nixos" "firewalld"];
      default = "nixos";
      description = "nixos: static per-interface rules (fixed network). firewalld: per-connection zones (roaming host).";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      networking.nftables.enable = true;
    }

    (lib.mkIf (cfg.backend == "nixos") {
      networking.firewall = {
        enable = true;
        allowPing = true;
        interfaces."enp5s0" = {
          allowedTCPPorts = [22]; # ssh from LAN
          allowedUDPPorts = [5353]; # mDNS
        };
      };
    })

    (lib.mkIf (cfg.backend == "firewalld") {
      networking.firewall.enable = false;
      services.firewalld = {
        enable = true;
        settings = {
          DefaultZone = "drop";
          FirewallBackend = "nftables";
        };
      };
    })
  ]);
}
