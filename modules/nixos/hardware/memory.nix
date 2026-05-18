{
  config,
  lib,
  ...
}: let
  cfg = config.my.hardware.memory;

  # Auto-derived values
  effectiveMemoryHigh =
    if cfg.memoryHighLimit != null
    then cfg.memoryHighLimit
    else "${toString (cfg.totalRamGb * 3 / 4)}G";

  effectiveZramPercent =
    if cfg.zram.memoryPercent != null
    then cfg.zram.memoryPercent
    else 50;

  effectiveSwapSize =
    if cfg.swap.size != null
    then cfg.swap.size
    else cfg.totalRamGb * 512;
in {
  options.my.hardware.memory = {
    enable = lib.mkEnableOption "Memory tuning and swap";

    totalRamGb = lib.mkOption {
      type = lib.types.int;
      description = ''
        Total system RAM in GiB. Used to auto-calculate memoryHighLimit
        (75%), zram size (50%), and swap size (50%).
      '';
    };

    memoryHighLimit = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Override systemd user DefaultMemoryHigh. Defaults to 75% of
        totalRamGb (e.g. "12G" for 16 GiB). Set explicitly to override.
      '';
    };

    zram = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      memoryPercent = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = ''
          Zram size as a percentage of RAM. Defaults to 50%. Set
          explicitly to override.
        '';
      };
    };

    swap = {
      device = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Swap device path, e.g. /swapfile or /dev/sdXn.";
      };
      size = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = ''
          Swap size in MiB. Defaults to 50% of totalRamGb. Set
          explicitly to override. Only used when device is a swapfile.
        '';
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
      DefaultMemoryHigh=${effectiveMemoryHigh}
    '';

    # Kernel memory tuning
    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 100;
      "vm.vfs_cache_pressure" = lib.mkDefault 50;
      "vm.dirty_background_ratio" = lib.mkDefault 5;
      "vm.dirty_ratio" = lib.mkDefault 10;
    };
    boot.kernelParams = lib.mkAfter ["lru_gen=1"];

    # Zram
    zramSwap = lib.mkIf cfg.zram.enable {
      enable = true;
      memoryPercent = effectiveZramPercent;
      algorithm = "zstd";
      priority = 100;
    };

    # Swap device
    swapDevices = lib.mkIf (cfg.swap.device != null) [
      {
        device = cfg.swap.device;
        priority = cfg.swap.priority;
        ${
          if cfg.swap.size != null || cfg.totalRamGb != null
          then "size"
          else null
        } =
          effectiveSwapSize;
      }
    ];
  };
}
