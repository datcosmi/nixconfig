{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/nixos/default.nix
    ../../profiles/personal.nix
    ../../profiles/gaming.nix
  ];

  networking.hostName = "suavicrema";
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  my.hardware = {
    gpu = "nvidia";
    ssd = true;
    hasBattery = false;

    memory = {
      enable = true;
      memoryHightLimit = "12G";
      zram.memoryPercent = 50;

      swap = {
        device = "/swapfile";
        size = 8192;
      };
    };

    display = {
      internalBacklight = false;
      ddc = true;
    };
  };

  my.features.desktop.niri.enable = true;

  system.stateVersion = "26.05";
}
