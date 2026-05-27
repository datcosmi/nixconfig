{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.my.features.gaming;
  hw = config.my.hardware;
in {
  imports = [
    ./steam.nix
    ./graphics.nix
    ./kernel.nix
    ./audio.nix
    ./wine.nix
    ./controllers.nix
  ];

  options = {
    # Hardware GPU extensions
    my.hardware.gpu = {
      amdGeneration = mkOption {
        type = types.enum [
          "gcn1"
          "gcn2"
          "gcn3"
          "gcn4"
          "gcn5"
          "rdna1"
          "rdna2"
          "rdna3"
          "rdna4"
        ];
        default = "rdna2";
        description = ''
          AMD GPU architecture generation.  Controls legacy kernel-param
          requirements (SI/CIK support), ROCm eligibility, and driver
          feature flags.  Only meaningful when
          my.hardware.gpu.vendor = "amd".
        '';
      };

      supportsROCm = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether this AMD GPU is supported by ROCm/HIP.  Polaris (GCN 4th gen)
          and newer generally work, but check the official matrix at
          https://rocm.docs.amd.com/en/latest/compatibility/compatibility-matrix.html.
          Note: AMD dropped Polaris from the official ROCm 4.5+ list; setting
          ROC_ENABLE_PRE_VEGA=1 re-enables it on those cards.
        '';
      };

      # Nvidia generation
      nvidiaGeneration = mkOption {
        type = types.enum [
          "maxwell"
          "pascal"
          "volta"
          "turing"
          "ampere"
          "ada"
          "blackwell"
        ];
        default = "ada";
        description = ''
          Nvidia GPU architecture generation.  Used to sanity-check
          gpu.openDrivers (open kernel modules require Turing or newer) and
          to apply generation-specific optimisations.  Only meaningful when
          my.hardware.gpu.vendor = "nvidia".
        '';
      };
    };

    # Master gaming options

    my.features.gaming = {
      enable = mkEnableOption ''
        gaming meta-feature.  Enables Steam, Gamescope, GameMode, Wine/Proton,
        low-latency audio, GPU-specific driver extras, kernel optimisations, and
        controller support.  Each sub-module can be toggled independently.
      '';

      # Steam sub-module options

      steam = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable Steam, GameMode, Gamescope, MangoHud and related tools.";
        };
        gamescope = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable the Gamescope micro-compositor.  Provides VRR, HDR
              passthrough, resolution scaling, and a Steam Deck-like session.
            '';
          };
          # capSysNice lets Gamescope renice itself for lower latency.
          # Requires the program.gamescope wrapper to set the capability.
          capSysNice = mkOption {
            type = types.bool;
            default = true;
            description = "Grant Gamescope CAP_SYS_NICE for real-time priority scheduling.";
          };
        };
        gamemode = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable Feral GameMode daemon (CPU governor switch, renice,
              I/O priority boost when a game is running).
            '';
          };
          renice = mkOption {
            type = types.bool;
            default = true;
            description = "Allow GameMode to renice game processes.";
          };
        };
        extraCompatPackages = mkOption {
          type = types.listOf types.package;
          default = [];
          description = "Extra Proton / compat tool packages added to Steam (e.g. proton-ge-bin).";
        };
      };

      # Graphics sub-module options

      graphics = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable GPU-specific graphics driver extras and Vulkan optimisations.";
        };
        enable32Bit = mkOption {
          type = types.bool;
          default = true;
          description = "Enable 32-bit graphics support (required for most Wine/Proton games).";
        };
        enableROCm = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Install ROCm / OpenCL ICD for AMD GPUs.  Requires
            my.hardware.gpu.supportsROCm = true and a Polaris / GCN4+ card.
          '';
        };
        amdPpFeatureMask = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "0xffffffff";
          description = ''
            Override amdgpu.ppfeaturemask kernel parameter.  Setting this to
            "0xffffffff" unlocks manual overclocking and fine-grained fan
            control.  Use with caution — incorrect values can damage hardware.
          '';
        };
        forceRADV = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Force Mesa RADV over AMDVLK for AMD GPUs by setting
            AMD_VULKAN_ICD=RADV globally.  RADV typically offers superior
            gaming performance and compatibility.
          '';
        };
        # Intel-specific
        intelGeneration = mkOption {
          type = types.enum [
            "pre-broadwell"
            "broadwell-plus"
            "xe"
          ];
          default = "broadwell-plus";
          description = ''
            Intel GPU/iGPU generation.  Determines which VA-API driver and
            QSV runtime package to install.  Only meaningful when
            my.hardware.gpu.vendor = "intel".
          '';
        };
      };

      # Kernel sub-module options

      kernel = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable kernel-level gaming optimisations: sysctl tuning
            (vm.max_map_count, scheduler latency, etc.) and boot parameters.
            Does NOT compile a custom kernel.
          '';
        };
        splitLockMitigate = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable kernel split-lock mitigation.  Disabled by default because
            several anti-cheat and older game engines trigger split locks,
            causing significant frame-time stalls.
          '';
        };
        # Whether to add "threadirqs" to boot params (routes IRQs through
        # kernel threads, reducing worst-case DPC latency on IRQ-heavy loads).
        threadedIRQs = mkOption {
          type = types.bool;
          default = true;
          description = "Route hardware IRQs through kernel threads (threadirqs).  Reduces latency spikes.";
        };
      };

      # Audio sub-module options

      audio = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Configure PipeWire for low-latency gaming audio.";
        };
        quantum = mkOption {
          type = types.ints.positive;
          default = 512;
          description = ''
            PipeWire/JACK buffer size in frames.  Lower values reduce audio
            latency at the cost of higher CPU usage and potential xruns.
            512 @ 48 kHz ≈ 10.7 ms — a solid gaming default.
            For audiophiles or streamers, 1024 is safer.  For low-latency
            setups (256 or below) ensure your system is properly tuned.
          '';
        };
        sampleRate = mkOption {
          type = types.ints.positive;
          default = 48000;
          description = "PipeWire default sample rate (Hz).  48000 matches most game/HDMI output.";
        };
      };

      # Wine / non-Steam launchers sub-module options

      wine = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable Wine, DXVK, VKD3D-Proton, and non-Steam game launchers.";
        };
        enableLutris = mkOption {
          type = types.bool;
          default = false;
          description = "Install Lutris game launcher (GOG, itch.io, Battle.net, etc.).";
        };
        enableBottles = mkOption {
          type = types.bool;
          default = false;
          description = "Install Bottles — a GUI Wine environment manager.";
        };
        enableHeroic = mkOption {
          type = types.bool;
          default = false;
          description = "Install Heroic Games Launcher (Epic, GOG, Amazon Gaming).";
        };
      };

      # Controller sub-module options

      controllers = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable gamepad / controller kernel drivers and udev rules.";
        };
        xbox = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable Xbox controller support.
            • hardware.xone    – USB dongle (Xbox Wireless Adapter) driver.
            • hardware.xpadneo – Bluetooth Xbox controller driver.
          '';
        };
        playstation = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable PlayStation DS4 / DualSense (DS5) controller udev rules
            and kernel module parameters so controllers are recognised without
            root privileges.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    my.features.gaming = {
      steam = {
        enable = mkDefault true;
        gamescope.enable = mkDefault true;
        gamemode.enable = mkDefault true;
      };
      graphics.enable = mkDefault true;
      kernel.enable = mkDefault true;
      audio.enable = mkDefault true;
      wine = {
        enable = mkDefault true;
        enableLutris = mkDefault false;
        enableBottles = mkDefault false;
        enableHeroic = mkDefault true;
      };
      controllers = {
        enable = mkDefault true;
        xbox = mkDefault true;
        playstation = mkDefault true;
      };
    };
  };
}
