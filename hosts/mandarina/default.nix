{...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "mandarina";

  my.hardware = {
    gpu = "nvidia";
    host = "laptop";
    hybrid = true;

    prime.intelBusId = "PCI:0:2:0";
    prime.nvidiaBusId = "PCI:1:0:0";

    display = {
      internalBacklight = true;
      ddc = false;
    };
  };

  my.profiles = ["base" "personal" "gaming"];

  system.stateVersion = "26.05";
}
