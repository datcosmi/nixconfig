{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.features.gaming.steam;
  hw = config.my.hardware;
  isNv = hw.gpu.vendor == "nvidia";
  isHybrid = hw.hybrid;
in {
  config = mkIf cfg.enable {
    # Steam

    programs.steam = {
      enable = true;
      # Open firewall ports for Steam Remote Play and in-home streaming.
      remotePlay.openFirewall = true;
      # Source Dedicated Server ports
      dedicatedServer.openFirewall = true;
      # Convenience: local network game transfers
      localNetworkGameTransfers.openFirewall = true;

      # GE-Proton ships with fixes and patches not yet in upstream Proton.
      # Additional packages can be injected via the option.
      extraCompatPackages = with pkgs;
        [proton-ge-bin] ++ cfg.extraCompatPackages;

      # Let Steam use the system MangoHud so hud config is centralised.
      extraPackages = with pkgs; [mangohud];
    };

    # Gamescope

    programs.gamescope = mkIf cfg.gamescope.enable {
      enable = true;
      # CAP_SYS_NICE lets Gamescope raise its own scheduling priority,
      # which reduces frame-time variance.
      capSysNice = cfg.gamescope.capSysNice;
    };

    # GameMode

    programs.gamemode = mkIf cfg.gamemode.enable {
      enable = true;
      enableRenice = cfg.gamemode.renice;

      settings = {
        general = {
          # Switch CPU governor to "performance" while a game is active.
          desiredgov = "performance";
          # Soften the renice target — "0" keeps default, negative values
          # raise priority (requires CAP_SYS_NICE or elevated permission).
          renice = 10;
          # Inhibit the screensaver while gaming.
          inhibit_screensaver = 1;
        };
        gpu = {
          # AMD: switch power-management profile to the highest clock state.
          # Nvidia: bump persistence mode (noop if nvidia-smi unavailable).
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          # amd_performance_level: "high" maps to DPM_FORCED_LEVEL_HIGH
          # which locks the GPU to max clocks.  "auto" is safer on laptops.
          amd_performance_level =
            if isHybrid
            then "auto"
            else "high";
        };
        cpu = {
          park_cores = "no"; # Do not park cores — hurts gaming latency.
          pin_cores = "yes"; # Pin game threads to physical cores.
        };
      };
    };

    # Packages

    environment.systemPackages = with pkgs; [
      # Performance overlay (FPS, frame time, GPU/CPU temps, VRAM).
      mangohud
      # GUI for managing GE-Proton versions installed outside of the Nix store.
      protonup-qt
    ];

    # Environment variables

    environment.sessionVariables = mkMerge [
      {
        # Tell Steam (and Proton) where to look for extra compatibility tools
        # installed imperatively by the user (e.g. via protonup-qt).
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";

        # Enable MangoHud for all Vulkan games by default.
        # Per-game overrides can be done via launch options: MANGOHUD=0 %command%
        MANGOHUD = "1";
      }
      # On a PRIME hybrid system give users a shortcut: run any command on the
      # discrete GPU via `prime-run <cmd>`.  Steam per-game launch option:
      #   prime-run %command%
      (mkIf (isNv && isHybrid) {
        # Already set by the nvidia module; reinforce here for clarity.
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      })
    ];

    # Security / capabilities
    security.rtkit.enable = true;

    # Allow GameMode to set higher scheduling priority without sudo.
    security.pam.loginLimits = [
      {
        domain = "@gamemode";
        type = "soft";
        item = "nice";
        value = "-10";
      }
      {
        domain = "@gamemode";
        type = "hard";
        item = "nice";
        value = "-15";
      }
      {
        domain = "@gamemode";
        type = "soft";
        item = "rtprio";
        value = "50";
      }
      {
        domain = "@gamemode";
        type = "hard";
        item = "rtprio";
        value = "50";
      }
    ];

    users.groups.gamemode = {};
  };
}
