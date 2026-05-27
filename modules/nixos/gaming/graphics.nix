{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.features.gaming.graphics;
  hw = config.my.hardware;
  vendor = hw.gpu.vendor;

  isAmd = vendor == "amd";
  isNvidia = vendor == "nvidia";
  isIntel = vendor == "intel";

  # AMD generation helpers
  amdGen = hw.gpu.amdGeneration;
  # GCN 1 (Southern Islands) needs radeon.si_support=0 amdgpu.si_support=1
  isGcn1 = amdGen == "gcn1";
  # GCN 2 (Sea Islands) needs radeon.cik_support=0 amdgpu.cik_support=1
  isGcn2 = amdGen == "gcn2";
  isLegacyGcn = isGcn1 || isGcn2;

  # Nvidia generation helpers
  nvGen = hw.gpu.nvidiaGeneration;
  # Open modules supported from Turing (RTX 20xx) onwards
  nvOpenOk = elem nvGen ["turing" "ampere" "ada" "blackwell"];

  # Intel generation helpers
  intelGen = cfg.intelGeneration;
  isIntelLegacy = intelGen == "pre-broadwell";
  isIntelXe = intelGen == "xe";
in {
  config = mkIf cfg.enable {
    # Core OpenGL / Vulkan

    hardware.graphics = {
      enable = true;
      enable32Bit = cfg.enable32Bit;

      extraPackages = with pkgs;
      # Packages present for every vendor
        [
          vulkan-validation-layers
        ]
        # AMD
        ++ optionals isAmd (
          [
            amdvlk
            # VAAPI decode / encode (via Mesa)
            mesa
          ]
          ++ optionals (cfg.enableROCm && hw.gpu.supportsROCm) [
            # ROCm OpenCL ICD
            rocmPackages.clr.icd
          ]
        )
        # Nvidia
        ++ optionals isNvidia [
          # Community VAAPI implementation for Nvidia (decode acceleration
          # in MPV, Firefox, etc.).
          nvidia-vaapi-driver
          # VDPAU → VA-API bridge so VDPAU-only applications can still use HW decode.
          libvdpau-va-gl
        ]
        # Intel
        ++ optionals isIntel (
          (
            if isIntelLegacy
            then [intel-vaapi-driver]
            else [intel-media-driver]
          ) # iHD  — Broadwell+
          ++ optionals isIntelXe [
            vpl-gpu-rt # oneVPL QSV runtime (Meteor Lake / Arc)
            intel-compute-runtime # OpenCL / Level Zero for Arc
          ]
          ++ optionals (!isIntelXe && !isIntelLegacy) [
            # 11th gen and newer still benefits from VPL:
            vpl-gpu-rt
          ]
        );

      # 32-bit counterparts (Wine / Proton need these)
      extraPackages32 = with pkgs.pkgsi686Linux;
        optionals isAmd [amdvlk]
        ++ optionals isIntel (
          if isIntelLegacy
          then [intel-vaapi-driver]
          else [intel-media-driver]
        );
    };

    # AMD-specific kernel parameters

    boot = mkMerge [
      # Early KMS for AMD: load the driver in initrd so the framebuffer is
      # available before the rootfs is mounted.
      (mkIf isAmd {
        initrd.kernelModules = ["amdgpu"];
      })

      # GCN 1 – Southern Islands: the amdgpu driver must be explicitly
      # requested because the kernel defaults to the legacy "radeon" driver.
      (mkIf (isAmd && isGcn1) {
        kernelParams = [
          "radeon.si_support=0"
          "amdgpu.si_support=1"
        ];
      })

      # GCN 2 – Sea Islands: same situation as GCN 1.
      (mkIf (isAmd && isGcn2) {
        kernelParams = [
          "radeon.cik_support=0"
          "amdgpu.cik_support=1"
        ];
      })

      # Optional ppfeaturemask override (unlocks overclocking UI in apps
      # like CoreCtrl or GreenWithEnvy).
      (mkIf (isAmd && cfg.amdPpFeatureMask != null) {
        kernelParams = ["amdgpu.ppfeaturemask=${cfg.amdPpFeatureMask}"];
      })

      # Nvidia: ensure DRM modesetting is active (required for Wayland and
      # PRIME offload).  The nvidia.nix module also does this; the merge is
      # idempotent.
      (mkIf isNvidia {
        kernelParams = ["nvidia-drm.modeset=1" "nvidia-drm.fbdev=1"];
      })

      # Intel: GuC / HuC firmware loading improves Xe LP scheduler quality.
      (mkIf (isIntel && !isIntelLegacy) {
        kernelParams = ["i915.enable_guc=3"];
      })
    ];

    # Ensure redistributable firmware blobs are available
    hardware.enableRedistributableFirmware = true;

    # ── Environment variables ──────────────────────────────────────────────

    environment.sessionVariables = mkMerge [
      # Prefer RADV over AMDVLK for AMD.
      (mkIf (isAmd && cfg.forceRADV) {
        AMD_VULKAN_ICD = "RADV";
      })

      # VA-API driver name for Intel
      (mkIf (isIntel && !isIntelLegacy) {
        LIBVA_DRIVER_NAME = "iHD";
      })
      (mkIf (isIntel && isIntelLegacy) {
        LIBVA_DRIVER_NAME = "i965";
      })

      # Polaris (GCN4)
      (mkIf (isAmd
        && hw.gpu.supportsROCm
        && elem amdGen ["gcn4" "gcn5"]) {
        ROC_ENABLE_PRE_VEGA = "1";
      })

      # ROCm HIP hard-codes /opt/rocm.
      (mkIf (isAmd && cfg.enableROCm && hw.gpu.supportsROCm) {
        ROCM_PATH = "/opt/rocm";
      })
    ];

    # ROCm expects /opt/rocm to exist; create a symlink via tmpfiles.
    systemd.tmpfiles.rules = mkIf (isAmd && cfg.enableROCm && hw.gpu.supportsROCm) [
      "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
    ];

    # Diagnostic / tooling packages

    environment.systemPackages = with pkgs;
      [
        vulkan-tools
        libva-utils
        mesa-demos
      ]
      ++ optionals isAmd [radeontop] # GPU usage monitor
      ++ optionals isNvidia [nvtopPackages.nvidia] # nvtop for Nvidia
      ++ optionals isAmd [nvtopPackages.amd]
      ++ optionals isIntel [nvtopPackages.intel]
      ++ optionals (isAmd && cfg.enableROCm && hw.gpu.supportsROCm) [
        rocmPackages.rocm-smi # AMD GPU management / monitoring
      ];

    # Nvidia open-driver sanity warning

    warnings = mkIf (isNvidia && hw.gpu.openDrivers && !nvOpenOk) [
      ''
        my.hardware.gpu.openDrivers = true, but my.hardware.gpu.nvidiaGeneration
        is set to "${nvGen}", which predates Turing.  The open kernel modules
        require a Turing (RTX 20xx) GPU or newer.  The build may fail or the
        GPU may not function correctly.  Set openDrivers = false for Pascal and
        older.
      ''
    ];
  };
}
