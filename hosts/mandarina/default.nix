{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/nixos
    ../../profiles/desktop.nix
    ../../profiles/gaming.nix
  ];

  networking.hostName = "mandarina";
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  my.hardware = {
    gpu = {
      vendor = "nvidia";
      openDrivers = false; # Nvidia MX150 needs the propietary drivers
      nvidiaPackage = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      nvidiaGeneration = "pascal";
    };

    hybrid = true;
    ssd = true;
    needSuspend = true;
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
      monitorsConfig = builtins.readFile ./niri/monitors.kdl;
      inputsConfig = builtins.readFile ./niri/inputs.kdl;
    };

    system.login.sddm = {
      enable = true;
      theme.silentSDDM = true;
    };

    boot.plymouth.enable = true;
    gaming.graphics.forceRADV = false;
  };

  catppuccin = {
    enable = true;
    autoEnable = false;
    cache.enable = true;

    grub = {
      enable = true;
      flavor = "mocha";
    };
  };

  programs.silentSDDM.theme = "catppuccin-mocha";

  system.stateVersion = "26.11";
}
