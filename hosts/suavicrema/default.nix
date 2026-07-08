{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../profiles/desktop.nix
    ../../profiles/gaming.nix

    ./edid
  ];

  networking.hostName = "suavicrema";

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
        maxPoolPercent = 25;
        shrinker = true;
      };

      swap = {
        device = "/var/lib/swapfile";
        size = 16 * 1024;
        priority = 10;
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

    system = {
      login.sddm = {
        enable = true;
        theme.silentSDDM = true;
      };

      services = {
        docker.enable = true;
        hamachi.enable = true;
        sunshine.enable = true;
      };
    };

    boot.plymouth.enable = true;

    theme.palette = "catppuccin-mocha";
  };

  system.stateVersion = "26.11";
}
