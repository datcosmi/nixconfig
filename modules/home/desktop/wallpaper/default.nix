{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.wallpaper;
in {
  options.my.features.desktop.wallpaper.enable = lib.mkEnableOption "Enable all wallpaper tools";

  config = lib.mkIf cfg.enable {
    my.features.desktop.wallpaper = {
      awww.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./awww.nix
  ];
}
