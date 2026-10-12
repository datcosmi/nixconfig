{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.recording;
in {
  options.my.features.desktop.apps.recording.enable = lib.mkEnableOption "Enable all recording related apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.recording = {
      obs-studio.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./obs-studio.nix
  ];
}
