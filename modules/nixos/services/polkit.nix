{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.security.polkitAgent;
in {
  options.my.features.system.security.polkitAgent.enable = lib.mkEnableOption "Polkit authentication agent";

  config = lib.mkIf cfg.enable {
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
      };
    };
  };
}
