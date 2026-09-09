{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.my.features.system.services.appimage;
in {
  options.my.features.system.services.appimage.enable = lib.mkEnableOption "Enable AppImage support";

  config = lib.mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    environment.systemPackages = with pkgs; [
      appimage-run
      gearlever
    ];
  };
}
