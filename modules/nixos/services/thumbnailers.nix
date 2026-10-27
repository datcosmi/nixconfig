{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ffmpegthumbnailer
      ffmpeg-headless
    ];

    environment.pathsToLink = [
      "/share/thumbnailers"
    ];
  };
}
