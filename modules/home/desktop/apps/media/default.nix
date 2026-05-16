{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.media;
in {
  options.my.features.desktop.apps.media.enable = lib.mkEnableOption "Enable all media apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.media = {
      localsend.enable = mkDefault true;
      vlc.enable = mkDefault true;
    };
  };

  imports = [
    ./localsend.nix
    ./vlc.nix
  ];
}
