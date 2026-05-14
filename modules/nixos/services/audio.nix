{
  lib,
  config,
  ...
}: let
  cfg = my.features.system.audio;
in {
  options.my.features.system.audio.enable = lib.mkEnableOption "Audio service";

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
