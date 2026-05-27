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
            "default.clock.allowed-rates" = [cfg.sampleRate];
            "default.clock.quantum" = cfg.quantum;
            "default.clock.min-quantum" = 64; # allow apps to go lower
            "default.clock.max-quantum" = 8192; # safety ceiling
          };

          # Raise PipeWire's own priority inside the RT group.
          "context.modules" = [
            {
              name = "libpipewire-module-rt";
              args = {
                "nice.level" = -11;
                "rt.prio" = 88;
                "rt.time.soft" = 200000; # µs
                "rt.time.hard" = 400000;
              };
              flags = ["ifexists" "nofail"];
            }
          ];
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
                  "audio.rate" = cfg.sampleRate;
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

    security.rtkit.enable = true;

    # Give audio/gaming users access to rtkit.
    security.pam.loginLimits = [
      {
        domain = "@audio";
        type = "soft";
        item = "rtprio";
        value = "88";
      }
      {
        domain = "@audio";
        type = "hard";
        item = "rtprio";
        value = "99";
      }
      {
        domain = "@audio";
        type = "soft";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "@audio";
        type = "hard";
        item = "memlock";
        value = "unlimited";
      }
    ];

    environment.systemPackages = with pkgs; [
      pwvucontrol
      crosspipe
      easyeffects
    ];
  };
}
