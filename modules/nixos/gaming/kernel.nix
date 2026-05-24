{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.gaming.kernel;
in {
  options.my.features.gaming.kernel = {
    enable = lib.mkEnableOption "Gaming kernel parameters and sysctl tweaks";

    patches = {
      enable = lib.mkEnableOption "NTSync kernel patch (requires full kernel recompile — slow!)";
    };
  };

  config = lib.mkIf cfg.enable {
    # NTSync — only built when explicitly enabled
    boot.kernelPatches = lib.mkIf cfg.patches.enable [
      {
        name = "ntsync-enable";
        patch = null;
        structuredExtraConfig = with lib.kernel; {
          NTSYNC = module;
        };
      }
    ];

    boot.kernelModules = lib.mkIf cfg.patches.enable ["ntsync"];

    services.udev.extraRules = lib.mkIf cfg.patches.enable ''
      # NTSync — allow any logged-in user to open the sync device
      KERNEL=="ntsync", TAG+="uaccess"
    '';

    # Kernel parameters
    boot.kernelParams = [
      "transparent_hugepage=madvise"
      "nowatchdog"
      "nmi_watchdog=0"
    ];

    # sysctl tweaks
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
