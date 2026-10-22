{
  lib,
  config,
  pkgs,
  hostname,
  ...
}: let
  cfg = config.my.features.system.services.audio;
  desktop = config.my.features.desktop;

  isDesktopPC = hostname == "suavicrema";
  bluetooth = config.my.features.system.services.bluetooth;
in {
  options.my.features.system.services.audio = {
    enable = lib.mkEnableOption "Audio service";
    defaultVolume = lib.mkOption {
      type = lib.types.float;
      default = 0.7;
      description = ''
        Initial volume (0.0–1.0) applied to new ALSA output nodes that have no
        saved WirePlumber state. WirePlumber remembers and restores any
        subsequent user changes automatically — this value only applies once,
        on the very first time a node is seen.
      '';
    };
    unmuteOnLogin = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Unmute the default sink on each graphical session start.";
    };
  };

  config = lib.mkIf (cfg.enable || desktop.enable) (lib.mkMerge [
    {
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;

        extraConfig = {
          pipewire."10-clock" = {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.allowed-rates" = [44100 48000 88200 96000 176400 192000];
              # Playback-focused: larger quantum = fewer xruns. Lower for live monitoring
              "default.clock.quantum" = 1024;
              "default.clock.min-quantum" = 256;
              "default.clock.max-quantum" = 2048;
            };
          };

          # PulseAudio-protocol clients
          pipewire-pulse."10-resample" = {
            "stream.properties" = {
              "resample.quality" = 10;
            };
          };

          # Native PipeWire clients
          client."10-resample" = {
            "stream.properties" = {
              "resample.quality" = 10;
            };
          };
        };

        wireplumber.enable = true;
        wireplumber.extraConfig = {
          "50-audio-config" = {
            "monitor.alsa.rules" = [
              {
                matches = [{"node.name" = "~alsa_output.*";}];
                actions.update-props = {
                  "node.volume" = cfg.defaultVolume;
                };
              }
            ];
          };

          "51-umc202hd" = lib.mkIf isDesktopPC {
            "monitor.alsa.rules" = [
              {
                matches = [{"node.name" = "~alsa_output.usb-BEHRINGER_UMC202HD.*";}];
                actions.update-props = {
                  "session.suspend-timeout-seconds" = 0; # never suspend, no pops
                  "node.volume" = 1.0; # use the hardware knob
                };
              }
              {
                matches = [{"node.name" = "~alsa_input.usb-BEHRINGER_UMC202HD.*";}];
                actions.update-props = {
                  "session.suspend-timeout-seconds" = 0;
                };
              }
            ];
          };

          "52-bluez" = lib.mkIf bluetooth.enable {
            "monitor.bluez.properties" = {
              "bluez5.enable-sbc-xq" = true;
              "bluez5.enable-msbc" = true;
              "bluez5.hfphsp-backend" = "native";
            };
          };
        };
      };

      environment.systemPackages = with pkgs; [
        pwvucontrol
        qpwgraph
        easyeffects
      ];
    }

    (lib.mkIf cfg.unmuteOnLogin {
      systemd.user.services.unmute-on-login = {
        description = "Unmute default audio sink on graphical session start";
        after = [
          "pipewire.service"
          "wireplumber.service"
        ];
        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 0";
        };
      };
    })
  ]);
}
