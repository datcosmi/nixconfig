{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.features.gaming.kernel;
  hw = config.my.hardware;
  vendor = hw.gpu.vendor;

  isAmd = vendor == "amd";
  isNvidia = vendor == "nvidia";
  isHybrid = hw.hybrid;
in {
  config = mkIf cfg.enable {
    # Boot parameters
    boot.kernelParams = mkMerge [
      [
        # Scheduler / latency

        # Use the "full" preemption model at runtime. Gives the lowest latency at the cost of
        # a tiny throughput reduction
        "preempt=full"

        # Route hardware IRQs through kernel threads so the scheduler can
        # manage their latency alongside normal tasks.
        (mkIf cfg.threadedIRQs "threadirqs")

        # Memory

        # Transparent Huge Pages: "madvise" lets processes opt-in
        # (Proton/DXVK do this), avoiding the system-wide memory waste of
        # "always" while still benefiting demanding workloads.
        "transparent_hugepage=madvise"

        # Split-lock mitigation

        # Several games and anti-cheat engines issue split-lock accesses.
        # With the default "warn" (or "fatal") policy these cause SIGBUS or
        # enormous latency spikes.  Disable unless explicitly requested.
        (
          if cfg.splitLockMitigate
          then "split_lock_detect=warn"
          else "split_lock_detect=off"
        )
      ]
    ];

    # sysctl tuning

    boot.kernel.sysctl = {
      # Virtual memory

      "vm.max_map_count" = 2147483642;

      # Reduce swappiness so game data stays in RAM;
      "vm.swappiness" = 10;

      # Allow dirty pages to accumulate slightly longer before writeback.
      # Reduces I/O jitter during asset streaming.
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;

      # Increase dirty expiry so that short write bursts (shader cache, save
      # games) don't immediately thrash the disk.
      "vm.dirty_expire_centisecs" = 3000;
      "vm.dirty_writeback_centisecs" = 1500;

      # File descriptor limits

      # Some engines (Unreal, id Tech) open vast numbers of asset files.
      "fs.file-max" = 524288;

      # CFS scheduler

      # Minimum time a task is guaranteed to run before being preempted.
      "kernel.sched_min_granularity_ns" = 500000; # 0.5 ms

      # Target scheduling latency: all runnable tasks should get to run at
      # least once within this window.
      "kernel.sched_latency_ns" = 4000000; # 4 ms

      # How much later a woken task can preempt the current task.  Lower
      # values cause more preemptions (good for responsiveness).
      "kernel.sched_wakeup_granularity_ns" = 50000; # 50 µs

      # Throttle migration of tasks between CPUs; keeping game threads on
      # the same CPU improves cache locality.
      "kernel.sched_migration_cost_ns" = 250000; # 250 µs

      # Network (online gaming / multiplayer)

      # Increase socket buffer sizes to reduce packet loss and jitter on
      # high-bandwidth game servers.
      "net.core.rmem_default" = 26214400; # 25 MiB
      "net.core.rmem_max" = 134217728; # 128 MiB
      "net.core.wmem_default" = 26214400;
      "net.core.wmem_max" = 134217728;
      "net.core.netdev_max_backlog" = 16384;
      "net.ipv4.tcp_rmem" = "4096 87380 134217728";
      "net.ipv4.tcp_wmem" = "4096 65536 134217728";
      "net.ipv4.udp_rmem_min" = 16384;
      "net.ipv4.udp_wmem_min" = 16384;
      # BBR congestion control — lower latency than CUBIC on lossy links.
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq";
      # Reduce TIME_WAIT socket accumulation for games that open many short
      # TCP connections.
      "net.ipv4.tcp_tw_reuse" = 1;
      "net.ipv4.tcp_fin_timeout" = 10;

      # IPC / shared memory

      # Some Vulkan workloads (especially DXVK shared-memory paths) need a
      # higher shared-memory segment limit.
      "kernel.shmmax" = 17179869184; # 16 GiB
      "kernel.shmall" = 4194304; # in pages (4 GiB at 4 K pages)
    };

    # Module parameters

    boot.extraModprobeConfig = mkMerge [
      # Increase the USB HID polling rate to 1000 Hz (1 ms) for mice and
      # gamepads.  Many mice ship at 125 Hz by default.
      ''
        options usbhid kbpoll=1 mousepoll=1 jspoll=1
      ''

      # AMD: enable ABGR surface format support on GCN5/RDNA; some Vulkan
      # games benefit from it.
      (mkIf isAmd ''
        options amdgpu abgr_support=1
      '')
    ];

    # BBR kernel module

    # BBR is compiled as a module in most configs; load it early so the sysctl
    # above takes effect before the network stack is fully up.
    boot.kernelModules = ["tcp_bbr"];

    # Packages

    environment.systemPackages = with pkgs; [
      # CPU performance governor and frequency monitoring.
      cpufrequtils
    ];
  };
}
