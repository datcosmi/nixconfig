{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming.gamemode;
in {
  options.my.features.gaming.gamemode = {
    enable = lib.mkEnableOption "GameMode CPU/GPU performance daemon";
  };

  config = lib.mkIf cfg.enable {
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
          ioprio = 0;
          inhibit_screensaver = 1;
        };
        cpu = {
          park_cores = "no";
          pin_cores = "yes";
        };
        gpu = {
          apply_gpu_optimisations = "0";
        };
        custom = {
          start = "${pkgs.procps}/bin/sysctl kernel.nmi_watchdog=0";
          end = "${pkgs.procps}/bin/sysctl kernel.nmi_watchdog=1";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      gamemode
    ];
  };
}
