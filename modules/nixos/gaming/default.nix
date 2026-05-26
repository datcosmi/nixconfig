{
  config,
  lib,
  ...
}: {
  imports = [
    ./kernel.nix
    ./steam.nix
    ./graphics.nix
    ./audio.nix
    ./gametools.nix
    ./peripherals.nix
  ];

  options.my.features.gaming = {
    enable = lib.mkEnableOption "Enable al gaming modules";
  };

  config = lib.mkIf config.my.features.gaming.enable {
    my.features.gaming.steam.enable = lib.mkDefault true;
    my.features.gaming.graphics.enable = lib.mkDefault true;
    my.features.gaming.audio.enable = lib.mkDefault true;
    my.features.gaming.gametools.enable = lib.mkDefault true;
    my.features.gaming.peripherals.enable = lib.mkDefault true;
  };
}
