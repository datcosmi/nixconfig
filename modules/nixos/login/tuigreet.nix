{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  # tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  # hyprland-session = "${pkgs.hyprland}/share/wayland-sessions";
  # waylandSessions = "/run/current-system/sw/share/wayland-sessions";
  waylandSessions = "/etc/wayland-sessions";
  cfg = config.my.features.system.login.tuigreet;
in {
  options.my.features.system.login.tuigreet.enable = lib.mkEnableOption "Use TUIGreet for login";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tuigreet
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # command = "${tuigreet} --time --remember --remember-session";
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${waylandSessions}";
          user = "greeter";
        };
      };
    };

    # this is a life saver.
    # literally no documentation about this anywhere.
    # might be good to write about this...
    # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
