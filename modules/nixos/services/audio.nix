{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.services.audio;
  desktop = config.my.features.desktop;
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

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
        wireplumber.extraConfig = {
          "50-audio-config" = {
            "monitor.alsa.rules" = [
              {
                matches = [{"node.name" = "~alsa_output.*";}];
                actions = {
                  update-props = {
                    "node.volume" = cfg.defaultVolume;
                  };
                };
              }
            ];
          };
        };
      };
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

    (lib.mkIf desktop.enable {
      environment.systemPackages = with pkgs; [
        pwvucontrol
        qpwgraph
        easyeffects
      ];
    })
  ]);
}
