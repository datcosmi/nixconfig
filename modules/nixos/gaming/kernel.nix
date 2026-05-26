{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming.kernel;
in {
  options.my.features.gaming.kernel = {
    enable = lib.mkEnableOption "Gaming kernel tweaks";

    ntsync = {
      enable =
        lib.mkEnableOption "NTSync kernel module for Wine/Proton"
        // {
          default = true;
        };
    };
  };

  config = lib.mkIf cfg.enable {
    # Load the module and set udev rule
    boot.kernelModules = lib.mkIf cfg.ntsync.enable ["ntsync"];

    services.udev.extraRules = lib.mkIf cfg.ntsync.enable ''
      KERNEL=="ntsync", TAG+="uaccess"
    '';

    boot.kernelParams = [
      "transparent_hugepage=madvise"
      "nowatchdog"
      "nmi_watchdog=0"
    ];

    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
      "vm.swappiness" = 10;
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.tcp_fastopen" = 3;
    };
  };
}
