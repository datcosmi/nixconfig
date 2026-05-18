{lib, ...}: {
  my.features = {
    desktop.enable = lib.mkDefault true;

    system = {
      services = {
        enable = lib.mkDefault true;
        security.polkitAgent.enable = lib.mkForce true;
      };

      networking.enable = lib.mkDefault true;
    };
  };
}
