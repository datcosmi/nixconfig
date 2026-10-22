{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.gaming;
  hw = config.my.hardware;
in {
  config = lib.mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      # Lets Gamescope renice itself to keep frame times steady.
      capSysNice = true;

      # Hybrid laptop: render Gamescope (and the game inside it) on the NVIDIA dGPU
      env = lib.optionalAttrs hw.hybrid {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    };

    programs.gamemode = {
      enable = true;
      settings.general.renice = 10;
    };
  };
}
