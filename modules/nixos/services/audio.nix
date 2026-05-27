{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.services.audio;
in {
  options.my.features.system.services.audio = {
    enable = lib.mkEnableOption "Audio service";

    defaultVolume = lib.mkOption {
      type = lib.types.str;
      default = "70%";
      description = "Default audio volume applied on login.";
    };

    unmuteOnLogin = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to unmute audio on login.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    systemd.user.services.default-volume = {
      description = "Set default audio volume";

      after = [
        "pipewire.service"
        "wireplumber.service"
      ];

      wantedBy = ["default.target"];

      serviceConfig = {
        Type = "oneshot";

        ExecStart = let
          muteCmd =
            if cfg.unmuteOnLogin
            then "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 0"
            else "";
        in ''
          ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ ${cfg.defaultVolume}
          ${muteCmd}
        '';
      };
    };
  };
}
