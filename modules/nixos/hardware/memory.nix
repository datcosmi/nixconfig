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
        type = lib.types.enum ["zstd" "lz4" "lzo" "lzo-rle" "deflate" "842"];
        default = "zstd";
        description = ''
          Compression algorithm. zstd is built into the kernel and
          recommended. lz4 requires boot.initrd.systemd.enable = true
          (this module sets it automatically when lz4 is chosen).
        '';
      };
      maxPoolPercent = lib.mkOption {
        type = lib.types.int;
        default = 20;
        description = ''
          Maximum percentage of RAM the zswap pool may occupy before it
          starts evicting pages to the backing swap device.
        '';
      };
      zpool = lib.mkOption {
        type = lib.types.enum ["zsmalloc" "z3fold" "zbud"];
        default = "zsmalloc";
        description = ''
          Memory allocator backend for the zswap pool.
          zsmalloc is the modern default (best memory efficiency).
          z3fold and zbud are older alternatives.
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

    boot.kernelParams = lib.mkAfter (
      # Multi-gen LRU — pairs well with both zram and zswap
      ["lru_gen=1"]
      ++ lib.optionals cfg.zswap.enable [
        "zswap.enabled=1"
        "zswap.compressor=${cfg.zswap.compressor}"
        "zswap.max_pool_percent=${toString cfg.zswap.maxPoolPercent}"
        "zswap.zpool=${cfg.zswap.zpool}"
        "zswap.shrinker_enabled=${
          if cfg.zswap.shrinker
          then "1"
          else "0"
        }"
      ]
    );

    # Load the zpool allocator module in the initrd so zswap can use it
    # immediately at boot. For lz4 we also need the compressor module;
    # zstd is built in and doesn't need this treatment.
    boot.initrd.kernelModules = lib.optionals cfg.zswap.enable (
      [cfg.zswap.zpool]
      ++ lib.optional (cfg.zswap.compressor == "lz4") "lz4"
    );

    # lz4 requires systemd-based initrd to load its module in time.
    boot.initrd.systemd.enable =
      lib.mkIf (cfg.zswap.enable && cfg.zswap.compressor == "lz4")
      (lib.mkDefault true);

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
