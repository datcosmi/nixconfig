{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.gaming.audio;
in {
  options.my.features.gaming.audio = {
    enable = lib.mkEnableOption "Low-latency PipeWire configuration for gaming";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      extraConfig.pipewire."92-gaming-latency" = {
        "context.properties" = {
          "default.clock.min-quantum" = 512;
          "default.clock.quantum" = 1024;
          "default.clock.max-quantum" = 2048;
        };
      };
    };

    security.rtkit.enable = true;

    environment.sessionVariables = {
      SDL_AUDIODRIVER = "pipewire";
    };
  };
}
