{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming.gametools;
in {
  options.my.features.gaming.gametools.enable = lib.mkEnableOption "GameMode, Gamescope, AppImage and RT priority limits";

  config = lib.mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

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
        gpu.apply_gpu_optimisations = "0";
        custom = {
          start = "${pkgs.procps}/bin/sysctl kernel.nmi_watchdog=0";
          end = "${pkgs.procps}/bin/sysctl kernel.nmi_watchdog=1";
        };
      };
    };

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    security.pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "soft";
        value = "70";
      }
      {
        domain = "@users";
        item = "rtprio";
        type = "hard";
        value = "99";
      }
      {
        domain = "@users";
        item = "memlock";
        type = "soft";
        value = "524288";
      }
      {
        domain = "@users";
        item = "memlock";
        type = "hard";
        value = "524288";
      }
    ];

    environment.systemPackages = with pkgs; [
      gamemode
      gamescope
    ];

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      liberation_ttf
    ];
  };
}
