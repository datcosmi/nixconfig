{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/nixos
    ../../profiles/desktop.nix
    ../../profiles/gaming.nix

    ./edid
  ];

  my.hardware = {
    gpu = {
      vendor = "nvidia";
      openDrivers = true;
      nvidiaGeneration = "turing";
    };

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
        maxPoolPercent = 30;
        shrinker = true;
      };

      swap = {
        device = "/var/lib/swapfile";
        size = 16 * 1024;
        priority = 100;
      };
    };

    display = {
      internalBacklight = false;
      ddc = true;
    };

    keyboard = {
      layout = "us,latam";
      variant = "altgr-intl,";
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
