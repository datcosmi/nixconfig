{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming.packages;
in {
  options.my.features.gaming.packages = {
    enable = lib.mkEnableOption "Gaming packages (Wine, launchers, overlays, tools)";

    wine.enable = lib.mkEnableOption "Wine and staging packages" // {default = true;};

    launchers.enable = lib.mkEnableOption "Third-party game launchers (Heroic, etc.)" // {default = true;};

    overlays.enable = lib.mkEnableOption "In-game overlays and GPU monitoring (MangoHud, vkBasAlt, GOverlay)" // {default = true;};

    appimage.enable = lib.mkEnableOption "AppImage support" // {default = true;};

    debug.enable = lib.mkEnableOption "Vulkan/GPU debugging and profiling tools";
  };

  config = lib.mkIf cfg.enable {
    programs.appimage = lib.mkIf cfg.appimage.enable {
      enable = true;
      binfmt = true;
    };

    environment.sessionVariables = lib.mkIf cfg.overlays.enable {
      ENABLE_VKBASALT = "0";
    };

    environment.systemPackages = with pkgs;
      lib.flatten [
        (lib.optionals cfg.wine.enable [
          wine64
          wineWow64Packages.stagingFull
        ])

        (lib.optionals cfg.launchers.enable [
          heroic
        ])

        (lib.optionals cfg.overlays.enable [
          mangohud
          vkbasalt
          goverlay
          gpu-screen-recorder
        ])

        (lib.optionals cfg.debug.enable [
          vulkan-tools
          mesa-demos
        ])
      ];
  };
}
