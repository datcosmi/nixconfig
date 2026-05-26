{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming.graphics;
  gpu = config.my.hardware.gpu;
  isAmd = gpu.vendor == "amd";
  isNvidia = gpu.vendor == "nvidia";
  isIntel = gpu.vendor == "intel";
in {
  options.my.features.gaming.graphics = {
    enable = lib.mkEnableOption "GPU/graphics gaming configuration";

    nvidia = {
      nvapi = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable NVAPI/NVNGX emulation via DXVK-NVAPI inside Proton.
          Required for DLSS to function in supported games.
          Has no effect on non-NVIDIA systems.
        '';
      };

      fsr = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable AMD FSR inside Gamescope as an upscaling fallback.
          Useful on NVIDIA since DLSS is not always available.
          Has no effect on non-NVIDIA systems.
        '';
      };

      deviceFilterName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          If set, DXVK will only expose the GPU whose name contains this
          string to the game. Useful on hybrid (PRIME) systems to prevent
          games from accidentally selecting the iGPU.
          Example: "RTX 4070"
        '';
      };

      openGlThreaded = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable NVIDIA threaded OpenGL optimisations (__GL_THREADED_OPTIMIZATIONS).
          Generally a free win for OpenGL games and Wine/Proton's OpenGL backend.
          Rarely causes issues; disable if you see rendering glitches.
        '';
      };

      powerMizer = lib.mkOption {
        type = lib.types.enum ["auto" "adaptive" "max"];
        default = "auto";
        description = ''
          NVIDIA PowerMizer mode:
          - auto:     let the driver decide (default, good for laptops)
          - adaptive: boost when under load, downclock at idle
          - max:      always run at maximum clocks (best desktop perf,
                      terrible for laptop battery)
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      extraPackages = with pkgs; [mesa];
      extraPackages32 = with pkgs; [pkgsi686Linux.mesa];
    };

    environment.sessionVariables = lib.mkMerge [
      (lib.mkIf isAmd {
        AMD_VULKAN_ICD = "RADV";
        RADV_PERFTEST = "aco";
        ENABLE_VKBASALT = "0";
      })

      (lib.mkIf isIntel {
        INTEL_VULKAN_ICD = "ANV";
        ENABLE_VKBASALT = "0";
      })

      (lib.mkIf isNvidia {
        ENABLE_VKBASALT = "0";

        PROTON_USE_WINED3D = "0";

        PROTON_NO_ESYNC = "1";
      })

      (lib.mkIf (isNvidia && cfg.nvidia.openGlThreaded) {
        __GL_THREADED_OPTIMIZATIONS = "1";
      })

      (lib.mkIf (isNvidia && cfg.nvidia.nvapi) {
        PROTON_ENABLE_NVAPI = "1";
        DXVK_ENABLE_NVAPI = "1";
      })

      (lib.mkIf (isNvidia && cfg.nvidia.fsr) {
        GAMESCOPE_FSR = "1";
      })

      (lib.mkIf (isNvidia && cfg.nvidia.deviceFilterName != null) {
        DXVK_FILTER_DEVICE_NAME = cfg.nvidia.deviceFilterName;
      })

      (lib.mkIf (isNvidia && cfg.nvidia.powerMizer != "auto") {
        __GL_PowerMizer_LEVEL =
          if cfg.nvidia.powerMizer == "adaptive"
          then "1"
          else "3";
      })
    ];

    environment.systemPackages = with pkgs; [
      mangohud
      vkbasalt
      goverlay
      vulkan-tools
      mesa-demos
      gpu-screen-recorder
    ];
  };
}
