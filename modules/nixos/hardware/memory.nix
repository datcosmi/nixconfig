{
  config,
  lib,
  pkgs,
  utils,
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

  # Derive the systemd swap unit name from the device path.
  # Only evaluated when swap.device is set, so the optionalString guard is safe.
  swapDeviceUnit =
    lib.optionalString (cfg.swap.device != null)
    "${utils.escapeSystemdPath cfg.swap.device}.swap";

  # Pass-through attrset for the native boot.zswap.* module
  # Keys are omitted when our own
  # option is left at its default (null), so the upstream module's own
  # default applies instead of us silently hardcoding one — this matters
  # most for zpool, where upstream auto-picks zsmalloc vs zbud based on
  # the actually configured kernel version (>= 6.3).
  zswapPassthru =
    {
      enable = true;
      compressor = cfg.zswap.compressor;
      shrinkerEnabled = cfg.zswap.shrinker;
    }
    // lib.optionalAttrs (cfg.zswap.zpool != null) {zpool = cfg.zswap.zpool;}
    // lib.optionalAttrs (cfg.zswap.maxPoolPercent != null) {
      maxPoolPercent = cfg.zswap.maxPoolPercent;
    }
    // lib.optionalAttrs (cfg.zswap.acceptThresholdPercent != null) {
      acceptThresholdPercent = cfg.zswap.acceptThresholdPercent;
    };
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
        description = ''
          Enable zram swap. Mutually exclusive with zswap — if both are
          set, evaluation will fail with an assertion error.
        '';
      };
      memoryPercent = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = ''
          Zram size as a percentage of RAM. Defaults to 50%.
        '';
      };
    };

    zswap = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable zswap, a compressed RAM cache in front of a disk-based
          swap device. Integrates with the kernel MM subsystem and
          automatically evicts cold pages to disk when the pool is full —
          unlike zram, there is no hard in-RAM capacity wall.
          Requires swap.device to be set. Mutually exclusive with zram.
        '';
      };
      compressor = lib.mkOption {
        type = lib.types.enum ["zstd" "lz4" "lzo" "lz4hc" "deflate" "842"];
        default = "zstd";
        description = ''
          Compression algorithm. zstd is built into the kernel and
          recommended. lz4/lz4hc require boot.initrd.systemd.enable = true
          for the compressor module to load early enough in the boot
          process (this module sets it automatically when lz4 or lz4hc
          is chosen)
        '';
      };
      maxPoolPercent = lib.mkOption {
        type = lib.types.nullOr (lib.types.ints.between 1 100);
        default = null;
        description = ''
          Maximum percentage of RAM the zswap pool may occupy before it
          starts evicting pages to the backing swap device. When null,
          defers to the upstream boot.zswap.maxPoolPercent default (25%).

          Recommended ranges: desktop 15-25%, low-memory 30-50%,
          server 10-20%.
        '';
      };
      acceptThresholdPercent = lib.mkOption {
        type = lib.types.nullOr (lib.types.ints.between 1 100);
        default = null;
        description = ''
          Pool-usage percentage at which zswap resumes accepting pages
          after hitting maxPoolPercent — hysteresis to prevent pool
          oscillation. When null, defers to the upstream
          boot.zswap.acceptThresholdPercent default (90%).
        '';
      };
      zpool = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum ["zsmalloc" "zbud"]);
        default = null;
        description = ''
          Memory allocator backend for the zswap pool. When null, the
          upstream module auto-selects zsmalloc on kernel >= 6.3 and
          zbud otherwise, based on the actual configured kernel package.
          zsmalloc offers the best density. z3fold was removed from the
          kernel in 6.8+ and is not a valid choice here.
        '';
      };
      shrinker = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Proactively shrink the zswap pool when the system is under
          memory pressure, rather than waiting for it to fill completely.
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
          Swap size in MiB. When set, NixOS creates and manages the
          swapfile (including btrfs CoW handling automatically).
          Defaults to 50% of totalRamGb. Only used when device is a
          swapfile.
        '';
      };
      priority = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };
      btrfsNoCow = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          For btrfs hosts: disable Copy-on-Write on the swapfile via
          chattr +C before the swap unit activates.

          When swap.size is set, NixOS already handles this automatically
          on modern releases — enabling this option in that case is
          harmless but redundant.

          This is most useful when swap.size is null (externally managed
          swapfile): a oneshot systemd service runs chattr +C before the
          swap unit, ensuring the attribute is set if not already present.
          Note that chattr +C only takes effect on empty files on btrfs;
          pre-existing swapfiles must have been created with +C from the
          start.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.zswap.enable && cfg.zram.enable);
        message = ''
          my.hardware.memory: zswap and zram cannot both be enabled.
          They serve overlapping roles; pick one. Use zswap when you
          have a real swap device and want graceful disk spillover; use
          zram when you want a pure in-RAM compressed swap pool.

          (The native boot.zswap module also enforces this directly
          against zramSwap.enable, so you'd hit it there too — this
          assertion just gives a clearer message in our own namespace.)
        '';
      }
      {
        assertion = !cfg.zswap.enable || cfg.swap.device != null;
        message = ''
          my.hardware.memory: zswap requires a backing swap device.
          Set swap.device to a swapfile or partition path.
        '';
      }
      {
        assertion = !cfg.swap.btrfsNoCow || cfg.swap.device != null;
        message = ''
          my.hardware.memory: swap.btrfsNoCow requires swap.device to
          be set.
        '';
      }
    ];

    # Memory pressure management
    systemd.oomd.enable = true;
    systemd.user.settings.Manager = {
      DefaultMemoryHigh = effectiveMemoryHigh;
    };

    # Kernel memory tuning
    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 100;
      "vm.vfs_cache_pressure" = lib.mkDefault 50;
      "vm.dirty_background_ratio" = lib.mkDefault 5;
      "vm.dirty_ratio" = lib.mkDefault 10;
    };

    # Multi-gen LRU — pairs well with both zram and zswap.
    # zswap's own kernel params and initrd modules are now supplied by
    # the native boot.zswap module below, not here.
    boot.kernelParams = lib.mkAfter ["lru_gen=1"];

    # lz4/lz4hc need a systemd-based initrd so the compressor module
    # loads early enough (the native boot.zswap module adds it to
    # boot.initrd.kernelModules, but doesn't fix load-ordering itself
    boot.initrd.systemd.enable =
      lib.mkIf (
        cfg.zswap.enable
        && (cfg.zswap.compressor == "lz4" || cfg.zswap.compressor == "lz4hc")
      )
      (lib.mkDefault true);

    # Zswap — native module. Handles kernelParams, initrd.kernelModules,
    # the runtime boot.kernel.sysfs values, and its own assertions
    # (zram conflict, swapDevices non-empty, zsmalloc kernel-version
    # gating) internally.
    boot.zswap = lib.mkIf cfg.zswap.enable zswapPassthru;

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

    # Btrfs CoW — external swapfiles only
    #
    # For NixOS-managed swapfiles (swap.size != null), NixOS already
    # creates the file with the correct btrfs attributes. We only add the
    # chattr service for externally managed files to ensure the attribute
    # is set before systemd activates the swap unit.
    systemd.services."swapfile-nocow" =
      lib.mkIf (
        cfg.swap.device
        != null
        && cfg.swap.btrfsNoCow
        && cfg.swap.size == null
      ) {
        description = "Disable Copy-on-Write on ${cfg.swap.device}";
        # Run before the swap unit that owns this device.
        wantedBy = [swapDeviceUnit];
        before = [swapDeviceUnit];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          # chattr is in e2fsprogs; +C is idempotent — safe to re-run.
          ExecStart = "${pkgs.e2fsprogs}/bin/chattr +C ${lib.escapeShellArg cfg.swap.device}";
        };
      };
  };
}
