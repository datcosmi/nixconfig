{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/nixos
    ../../profiles/personal.nix
    ../../profiles/gaming.nix
  ];

  networking.hostName = "suavicrema";
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  my.hardware = {
    gpu = "nvidia";
    openDrivers = true;
    ssd = true;
    needSuspend = false;
    hasWifi = true;

    memory = {
      enable = true;
      totalRamGb = 16;
      zram.enable = true;
      swap.device = "/swapfile";
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

    system.login.tuigreet.enable = true;
  };

  system.stateVersion = "26.05";
}
