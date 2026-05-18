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
    # Kernel
    boot.kernelPatches = [
      {
        name = "ntsync-enable";
        patch = null;
        structuredExtraConfig = with lib.kernel; {
          NTSYNC = module;
        };
      }
    ];

    boot.kernelModules = ["ntsync"];

    services.udev.extraRules = ''
      # NTSync — allow any logged-in user to open the sync device
      KERNEL=="ntsync", TAG+="uaccess"
    '';

    # Kernel parameters

    boot.kernelParams = [
      "transparent_hugepage=madvise"
      "nowatchdog"
      "nmi_watchdog=0"
    ];

    # sysctl tweaks

    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642;

      "vm.swappiness" = 10;

      "kernel.sched_cfs_bandwidth_slice_us" = 3000;

      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.tcp_fastopen" = 3;
    };

    # Graphics / OpenGL

    hardware.graphics = {
      extraPackages = with pkgs; [
        mesa
      ];
      extraPackages32 = with pkgs; [
        pkgs.pkgsi686Linux.mesa
      ];
    };

    # Steam

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

    # Gamescope

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    # GameMode

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

    # Audio

    services.pipewire = {
      extraConfig.pipewire."92-gaming-latency" = {
        "context.properties" = {
          "default.clock.min-quantum" = 512;
          "default.clock.quantum" = 1024;
          "default.clock.max-quantum" = 2048;
        };
      };
    };

    security.rtkit.enable = true;

    # AppImage support

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    # Controller / peripheral support

    hardware.steam-hardware.enable = true;

    hardware.xone.enable = true;

    # System packages

    environment.systemPackages = with pkgs; [
      dualsensectl # Dualsense support
      # lutris
      heroic
      # bottles
      protonup-qt

      # Proton / Wine utilities
      protontricks
      winetricks
      wine64
      wineWow64Packages.stagingFull

      # Overlays & monitoring
      mangohud
      vkbasalt

      # Debugging & profiling
      goverlay
      vulkan-tools
      mesa-demos
      gpu-screen-recorder

      # Misc gaming utils
      gamemode
      gamescope
    ];

    # Environment variables

    environment.sessionVariables = {
      SDL_AUDIODRIVER = "pipewire";
      AMD_VULKAN_ICD = "RADV";
      RADV_PERFTEST = "aco";
      ENABLE_VKBASALT = "0";
    };

    # Security / real-time priorities

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

    # Fonts (CJK + symbol coverage for game UIs)

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      liberation_ttf
    ];
  };
}
