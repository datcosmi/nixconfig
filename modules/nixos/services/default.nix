{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.services;
in {
  imports = [
    ./core.nix

    ./printing.nix
    ./bluetooth.nix
    ./audio.nix
    ./flatpak.nix
    ./keyring.nix
    ./polkit.nix
  ];

  options.my.features.system.services.enable = lib.mkEnableOption "System services";

  config = lib.mkIf cfg.enable {
    my.features.system = {
      services = {
        bluetooth.enable = lib.mkDefault true;
        audio.enable = lib.mkDefault true;
        flatpak.enable = lib.mkDefault true;
        printing.enable = lib.mkDefault true;

        security = {
          gnomeKeyring.enable = lib.mkDefault true;
          polkitAgent.enable = lib.mkDefault true;
        };
      };
    };
  };
}
