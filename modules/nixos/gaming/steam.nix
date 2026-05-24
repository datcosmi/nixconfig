{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming.steam;
in {
  options.my.features.gaming.steam = {
    enable = lib.mkEnableOption "Steam and Proton";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "proton-ge-bin"
      ];

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

    environment.systemPackages = with pkgs; [
      protontricks
      winetricks
      protonup-qt
    ];
  };
}
