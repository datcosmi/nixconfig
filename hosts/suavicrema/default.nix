{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/nixos
    ../../profiles/desktop.nix
    ../../profiles/gaming.nix

    ./edid
  ];

  networking.hostName = "suavicrema";
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

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
      zram.enable = true;
    };

    display = {
      internalBacklight = false;
      ddc = true;
    };

    keyboard = {
      layout = "us";
      variant = "altgr-intl";
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
    cache.enable = true;

    grub = {
      enable = true;
      flavor = "mocha";
    };
  };

  programs.silentSDDM.theme = "catppuccin-mocha";

  system.stateVersion = "26.05";
}
