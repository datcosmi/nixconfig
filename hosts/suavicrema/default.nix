{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/nixos/default.nix
    ../../profiles/personal.nix
    ../../profiles/gaming.nix
  ];

  networking.hostName = "suavicrema";

  my.hardware = {
    gpu = "nvidia";

    display = {
      internalBacklight = false;
      ddc = true;
    };
  };

  my.features.desktop.niri.enable = true;

  system.stateVersion = "26.05";
}
