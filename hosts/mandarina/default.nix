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
    };

    hybrid = true;
    ssd = true;
    needSuspend = true;
    hasWifi = true;

    memory = {
      enable = true;
      totalRamGb = 16;
      zram.enable = true;
      swap.device = "/swapfile";
    };

    prime.intelBusId = "PCI:0:2:0";
    prime.nvidiaBusId = "PCI:1:0:0";

    display = {
      internalBacklight = true;
      ddc = false;
    };

    keyboard = {
      layout = "latam";
      keyMap = "la-latin1";
      variant = "";
    };
  };

  my.features = {
    desktop.niri = {
      enable = true;
      monitorsConfig = builtins.readFile ./niri/monitors.kdl;
      inputsConfig = builtins.readFile ./niri/inputs.kdl;
    };

    # system.login.tuigreet.enable = true;
    system.login.sddm = {
      enable = true;
      theme.silentSDDM = true;
    };

    gaming.graphics.nvidia = {
      nvapi = false;
      fsr = true;
      openGlThreaded = true;
      powerMizer = "adaptive";
      deviceFilterName = "MX150";
    };
  };

  catppuccin = {
    cache.enable = true;
    grub = {
      enable = true;
      flavor = "mocha";
    };
  };

  programs.silentSDDM.theme = "catppuccin-mocha";

  system.stateVersion = "26.05";
}
