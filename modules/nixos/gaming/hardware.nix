{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming.hardware;
in {
  options.my.features.gaming.hardware = {
    enable = lib.mkEnableOption "Gaming hardware support (graphics + controllers)";

    controllers = {
      steam.enable = lib.mkEnableOption "Steam hardware (controllers, link, deck)" // {default = true;};

      xone.enable = lib.mkEnableOption "Xbox One/Series wired controller driver (requires kernel module build — slow!)";

      dualsense.enable = lib.mkEnableOption "DualSense (PS5) controller utilities";
    };
  };

  config = lib.mkIf cfg.enable {
    # Graphics / OpenGL
    hardware.graphics = {
      extraPackages = with pkgs; [mesa];
      extraPackages32 = with pkgs; [pkgs.pkgsi686Linux.mesa];
    };

    environment.sessionVariables = {
      AMD_VULKAN_ICD = "RADV";
      RADV_PERFTEST = "aco";
    };

    # Controllers
    hardware.steam-hardware.enable = lib.mkIf cfg.controllers.steam.enable true;

    hardware.xone.enable = lib.mkIf cfg.controllers.xone.enable true;

    environment.systemPackages = lib.mkIf cfg.controllers.dualsense.enable (with pkgs; [
      dualsensectl
    ]);
  };
}
