{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.waylandLockSuspend;

  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  wlopm = "${pkgs.wlopm}/bin/wlopm";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  loginctl = "${pkgs.systemd}/bin/loginctl";
in {
  # Options

  options.custom.waylandLockSuspend = {
    enable = lib.mkEnableOption "screen lock and suspend (hyprlock + swayidle)";

    lockTimeout = lib.mkOption {
      type = lib.types.int;
      default = 300;
      description = "Idle seconds before the screen locks.";
    };

    screenOffTimeout = lib.mkOption {
      type = lib.types.int;
      default = 330;
      description = "Idle seconds before monitors are powered off (should be >= lockTimeout).";
    };

    suspendTimeout = lib.mkOption {
      type = lib.types.int;
      default = 900;
      description = "Idle seconds before the system suspends.";
    };

    # Appearance

    blurPasses = lib.mkOption {
      type = lib.types.int;
      default = 3;
      description = "Background blur passes in hyprlock (0 to disable).";
    };

    gracePeriod = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "Seconds after lock triggers during which mouse movement cancels it.";
    };

    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "monospace";
      description = "Font used for the clock and date on the lock screen.";
    };
  };

  # Implementation

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.wlopm
    ];

    # hyprlock
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = false;
          hide_cursor = true;
          grace = cfg.gracePeriod;
          no_fade_in = false;
          no_fade_out = false;
          # Ensure hyprlock stays on top even on niri
          immediate_render = true;
        };

        # Blurred screenshot as background on every monitor
        background = [
          {
            monitor = "";
            path = "screenshot";
            blur_passes = cfg.blurPasses;
            blur_size = 7;
            brightness = 0.5;
            contrast = 0.9;
            vibrancy = 0.2;
          }
        ];

        # Password input field
        input-field = [
          {
            monitor = "";
            size = "280, 52";
            position = "0, -90";
            halign = "center";
            valign = "center";

            outline_thickness = 2;
            outer_color = "rgb(24, 25, 38)";
            inner_color = "rgb(54, 58, 79)";
            font_color = "rgb(202, 211, 245)";

            dots_center = true;
            dots_size = 0.25;
            fade_on_empty = true;
            placeholder_text = ''<span foreground="##a5adcb">Password…</span>'';

            shadow_passes = 3;
            shadow_size = 4;

            fail_color = "rgb(237, 135, 150)";
            fail_text = "<i>Incorrect</i>";
            fail_transition = 300;
          }
        ];

        # Clock label
        label = [
          {
            monitor = "";
            text = ''cmd[update:18000000] echo "$(date +'%H:%M')"'';
            color = "rgb(202, 211, 245)";
            font_size = 88;
            font_family = cfg.fontFamily;
            position = "0, 180";
            halign = "center";
            valign = "center";
            shadow_passes = 3;
          }
          {
            monitor = "";
            text = ''cmd[update:18000000] echo "$(date +'%A, %B %-d')"'';
            color = "rgb(166, 173, 200)";
            font_size = 22;
            font_family = cfg.fontFamily;
            position = "0, 80";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    # swayidle
    services.swayidle = {
      enable = true;

      extraArgs = ["-w"];

      timeouts = [
        {
          timeout = cfg.lockTimeout;
          command = "${hyprlock}";
        }

        {
          timeout = cfg.screenOffTimeout;
          command = "${wlopm} --off '*'";
          resumeCommand = "${wlopm} --on  '*'";
        }

        {
          timeout = cfg.suspendTimeout;
          command = "${hyprlock} & sleep 2 && ${systemctl} suspend";
        }
      ];

      events = {
        lock = "${hyprlock}";
        before-sleep = "${hyprlock} & sleep 2";
        after-resume = "${wlopm} --on '*'";
      };
    };
  };
}
