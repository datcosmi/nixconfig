{lib, ...}: {
  my.features.gaming = {
    kernel = {
      enable = true;
      patches.enable = false; # Set to true only when wanting NTSync (costs a full kernel recompile)
    };

    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
    audio.enable = true;

    hardware = {
      enable = true;
      controllers = {
        steam.enable = true;
        xone.enable = false; # Set to true only when needing Xbox wired controllers (costs kernel module build)
        dualsense.enable = true;
      };
    };

    packages = {
      enable = true;
      wine.enable = true;
      launchers.enable = true;
      overlays.enable = true;
      appimage.enable = true;
      debug.enable = false; # Vulkan/GPU debug tools — enable when needed
    };

    security.enable = true;
    fonts.enable = true;
  };
}
