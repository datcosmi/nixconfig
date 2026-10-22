{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming;
in {
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;

      # Remote Play (stream to TV/phone) and LAN game transfers
      remotePlay.openFirewall = lib.mkDefault false;
      localNetworkGameTransfers.openFirewall = lib.mkDefault false;

      # GE-Proton
      extraCompatPackages = [pkgs.proton-ge-bin];

      protontricks.enable = true;

      # MangoHud inside Steam's FHS environment.
      extraPackages = [pkgs.mangohud];

      package = pkgs.steam.override {
        extraEnv.MANGOHUD = "1"; # Toggle in-game with Right Shift + F12
      };
    };

    environment.systemPackages = [
      pkgs.mangohud # for non-Steam games
      pkgs.heroic
    ];
  };
}
