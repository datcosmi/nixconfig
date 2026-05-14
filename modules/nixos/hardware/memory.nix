{
  config,
  lib,
  ...
}: let
  cfg = config.my.hardware.memory;
in {
  options.my.hardware.memory = {
    enable = lib.mkEnableOption "Memory tuning and swap";

    memoryHighLimit = lib.mkOption {
      type = lib.types.str;
      default = "infinity";
      description = "systemd user DefaultMemoryHigh — cap per-user memory";
    };

    zram = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      memoryPercent = lib.mkOption {
        type = lib.types.int;
        default = 50;
      };
    };

    swap = {
      device = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      size = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
      priority = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Memory pressure management
    systemd.oomd.enable = true;
    systemd.user.extraConfig = ''
      DefaultMemoryHigh=${cfg.memoryHighLimit}
    '';

    # Kernel memory tuning
    boot.kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_background_ratio" = 5;
      "vm.dirty_ratio" = 10;
    };
    boot.kernelParams = lib.mkAfter ["lru_gen=1"];

    # Zram
    zramSwap = lib.mkIf cfg.zram.enable {
      enable = true;
      memoryPercent = cfg.zram.memoryPercent;
      algorithm = "zstd";
      priority = 100;
    };

    # Swap device
    swapDevices = lib.mkIf (cfg.swap.device != null) [
      {
        device = cfg.swap.device;
        priority = cfg.swap.priority;
        ${
          if cfg.swap.size != null
          then "size"
          else null
        } =
          cfg.swap.size;
      }
    ];
  };
}
