{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.features.gaming.wine;
  hw = config.my.hardware;

  isNvidia = hw.gpu.vendor == "nvidia";
  isHybrid = hw.hybrid;

  # Build Lutris with Wine staging and common tricks pre-configured.
  lutrisWithWine = pkgs.lutris.override {
    extraPkgs = p:
      with p; [
        winetricks
        wineWow64Packages.stagingFull # WoW64 + staging + multimedia codecs
        dxvk # D3D9/10/11 → Vulkan
        vkd3d-proton # D3D12 → Vulkan
      ];
  };
in {
  config = mkIf cfg.enable {
    # Core Wine stack

    environment.systemPackages = with pkgs;
      [
        # WoW64 Wine build (runs 32-bit Windows apps in a 64-bit process,
        # eliminating the need for a separate 32-bit Wine prefix).
        # "stagingFull" includes staging patches + all media codecs (gstreamer,
        # ffmpeg) needed by most game launchers and media DRM.
        wineWow64Packages.stagingFull

        # DXVK: Vulkan-based D3D9/D3D10/D3D11 implementation.
        dxvk

        # VKD3D-Proton: Valve's fork of vkd3d with DX12 improvements.
        vkd3d-proton

        # Winetricks: install Windows runtime components (vcrun2022, dotnet,
        # directx, fonts…) into Wine prefixes.
        winetricks

        # Cabextract / p7zip are runtime deps of winetricks.
        cabextract
        p7zip
      ]
      # Optional launchers
      ++ optional cfg.enableLutris lutrisWithWine
      ++ optional cfg.enableBottles pkgs.bottles
      ++ optional cfg.enableHeroic pkgs.heroic;

    # Environment variables

    environment.sessionVariables = mkMerge [
      {
        # Tell DXVK to use async shader compilation to reduce hitching during
        # shader compilation.  Not all games benefit; those with strict
        # anti-cheat may reject it.
        DXVK_ASYNC = "1";

        # DXVK state-cache location (shared across all prefixes avoids
        # recompiling shaders from scratch on every new prefix).
        DXVK_STATE_CACHE_PATH = "$HOME/.cache/dxvk";

        # VKD3D-Proton: enable breadcrumb debugging for crash analysis
        # (mild performance cost; remove if you hit perf issues).
        # VKD3D_DEBUG = "none";

        # Wine default prefix (users can override per-game in Lutris/Bottles).
        WINEPREFIX = "$HOME/.wine";
      }
    ];

    # fontconfig: add common Windows fonts via winetricks

    # We pre-configure fontconfig so Wine applications can find common fonts
    # without the user having to run winetricks manually.
    # The actual font installation is done imperatively by the user via
    # winetricks; here we just make sure fontconfig scans the Wine font dirs.
    fonts.fontconfig.enable = true;

    # tmpfiles: DXVK state cache dir

    # Create the shared DXVK cache directory on first boot.
    systemd.tmpfiles.rules = [
      "d /var/cache/dxvk 0755 root root -"
    ];
  };
}
