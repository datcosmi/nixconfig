{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.torrent;
in {
  options.my.features.desktop.apps.torrent.enable = lib.mkEnableOption "Enable all torrent apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.torrent = {
      qbittorrent.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./qbittorrent.nix
  ];
}
