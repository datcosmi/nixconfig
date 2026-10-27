{config, ...}: {
  imports = [
    ../../profiles/desktop.nix
    ../../profiles/gaming.nix
  ];

  networking.hostName = "mandarina";

  my.hardware = {
    gpu = {
      vendor = "nvidia";
      openDrivers = false; # Nvidia MX150 needs the propietary drivers
      nvidiaPackage = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    };

    hybrid = true;
    ssd = true;
    needSuspend = true;
    hasBattery = true;
    hasWifi = true;

    memory = {
      enable = true;
      totalRamGb = 16;
      zram.enable = false;

      zswap = {
        enable = true;
        compressor = "zstd";
        zpool = "zsmalloc";
        maxPoolPercent = 25;
        shrinker = true;
      };

      swap = {
        device = "/var/lib/swapfile";
        size = 16 * 1024;
        priority = 10;
      };
    };

    prime.intelBusId = "PCI:0:2:0";
    prime.nvidiaBusId = "PCI:1:0:0";

    display = {
      internalBacklight = true;
      ddc = false;
    };

    keyboard = {
      layout = "latam,us";
      keyMap = "la-latin1";
      variant = ",altgr-intl";
    };
  };

  my.features = {
    desktop.niri = {
      enable = true;
      monitorsConfig = import ./_niri/monitors.nix;
      inputsConfig = import ./_niri/inputs.nix;
    };

    system = {
      login.sddm = {
        enable = true;
        theme.silentSDDM = true;
      };

      services.docker.enable = true;
    };

    boot.plymouth.enable = true;

    theme.palette = "catppuccin-mocha";
  };

  system.stateVersion = "26.11";
}
