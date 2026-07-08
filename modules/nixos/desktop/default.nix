{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop;
in {
  imports = [
    ./apps
    ./wm
    ./themes
  ];

  options.my.features.desktop.enable = lib.mkEnableOption "Desktop stack";

  config = lib.mkIf cfg.enable {
    my.features.desktop = {
      apps.enable = lib.mkDefault true;
    };

    # Ensure sessions are allways locked before suspend
    systemd.services.lock-before-sleep = {
      description = "Lock all sessions before suspend";
      before = ["sleep.target"];
      wantedBy = ["sleep.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/loginctl lock-session";
      };
    };
  };
}
