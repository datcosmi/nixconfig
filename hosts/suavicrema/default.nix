{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "suavicrema";

  my.hardware = {
    gpu = "nvidia";
    host = "desktop";

    display = {
      internalBacklight = false;
      ddc = true;
    };
  };

  my.profiles = ["base" "personal" "gaming"];

  system.stateVersion = "26.05";
}
