{
  config,
  lib,
  ...
}: {
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
    priority = 100;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096;
      priority = 0;
    }
  ];

  # Kernel memory tuning
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
  };

  # Better memory reclaim
  boot.kernelParams = lib.mkAfter [
    "lru_gen=1"
  ];

  # Prevent system freezes under memory pressure
  systemd.oomd.enable = true;
}
