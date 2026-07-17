{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.features.gaming.audio;
  q = toString cfg.quantum;
  sr = toString cfg.sampleRate;
in {
  config = mkIf cfg.enable {
    services.pipewire = {
      extraConfig.pipewire = {
        # Context-level defaults: sample rate and buffer quantum.
        "99-gaming-defaults" = {
          "context.properties" = {
            "default.clock.rate" = cfg.sampleRate;
            "default.clock.allowed-rates" = [cfg.allowedSampleRates];
            "default.clock.quantum" = cfg.quantum;
            "default.clock.min-quantum" = 64; # allow apps to go lower
            "default.clock.max-quantum" = 8192; # safety ceiling
          };
        };
      };

      wireplumber.extraConfig = {
        # Set the default node quantum for new audio clients that do not
        # request their own period size.
        "99-gaming-quantum" = {
          "monitor.alsa.rules" = [
            {
              matches = [{"node.name" = "~alsa_output.*";}];
              actions = {
                update-props = {
                  "audio.format" = "S32LE";
                  "api.alsa.period-size" = cfg.quantum;
                  # Double-buffering: 2 × quantum = total buffer latency.
                  "api.alsa.headroom" = 0;
                };
              };
            }
          ];
        };
      };
    };
  };
}
