{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming;
in {
  options.my.features.gaming.enable = lib.mkEnableOption "Gaming-oriented system configuration";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;

      gamescopeSession.enable = true;

      protontricks.enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
