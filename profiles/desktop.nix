{lib, ...}: {
  my.features = {
    desktop.enable = lib.mkDefault true;

    system = {
      services.enable = lib.mkDefault true;
      networking.enable = lib.mkDefault true;
    };
  };
}
