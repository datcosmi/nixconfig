{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming;
in {
  options.my.features.gaming = {
    enable = lib.mkEnableOption "gaming support (Steam, Proton, GameMode, etc.)";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;

      gamescopeSession.enable = true;
      protontricks.enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    environment.systemPackages = with pkgs; [
      steam-run
      protontricks
      winetricks
      protonup-qt
      # mangohud
      gamemode

      (writeShellScriptBin "protontricks" ''
        exec ${steam-run}/bin/steam-run ${protontricks}/bin/protontricks "$@"
      '')
    ];

    programs.gamemode.enable = true;

    services.udev.packages = [pkgs.gamemode];

    boot.kernelModules = lib.mkAfter ["ntsync"];
    boot.kernel.sysctl."kernel.ntsync" = 1;
    boot.kernel.sysctl."kernel.sched_latency_ns" = 1000000;

    # environment.variables.MANGOHUD = "1";

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
