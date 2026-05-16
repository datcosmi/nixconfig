{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.torrent.qbittorrent;
in {
  options.my.features.desktop.apps.torrent.qbittorrent.enable = lib.mkEnableOption "Enable QbitTorrent app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      qbittorrent
    ];
  };
}
