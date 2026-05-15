{...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/nixos/default.nix
    ../../profiles/personal.nix
    ../../profiles/gaming.nix
  ];

  networking.hostName = "mandarina";
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  my.hardware = {
    gpu = "nvidia";
    hybrid = true;
    ssd = true;
    hasBattery = true;

    memory = {
      enable = true;
      memoryHighLimit = "12G";
      zram.memoryPercent = 50;

      swap = {
        device = "/swapfile";
        size = 8192;
      };
    };

    prime.intelBusId = "PCI:0:2:0";
    prime.nvidiaBusId = "PCI:1:0:0";

    display = {
      internalBacklight = true;
      ddc = false;
    };

    keyboard = {
      layout = "latam";
      variant = "";
    };
  };

  my.features.desktop.niri.enable = true;

  system.stateVersion = "26.05";
}
