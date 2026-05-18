{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.services.security.polkitAgent;

  agents = {
    gnome = {
      package = pkgs.polkit_gnome;
      binary = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };
    lxqt = {
      package = pkgs.lxqt.lxqt-policykit;
      binary = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
    };
    kde = {
      package = pkgs.kdePackages.polkit-kde-agent-1;
      binary = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
    };
  };

  selectedAgent = agents.${cfg.agent};
in {
  options.my.features.system.services.security.polkitAgent = {
    enable = lib.mkEnableOption "Polkit authentication agent";

    agent = lib.mkOption {
      type = lib.types.enum (builtins.attrNames agents);
      default = "gnome";
      description = "Which polkit authentication agent to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.polkit-authentication-agent = {
      description = "Polkit authentication agent";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = selectedAgent.binary;
        Restart = "on-failure";
      };
    };
  };
}
