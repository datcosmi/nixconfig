{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  wayland = osConfig.my.features.wayland;
  cfg = config.my.features.desktop.clipboard.cliphist;
in {
  options.my.features.desktop.clipboard.cliphist.enable = lib.mkEnableOption "Enable cliphist service";

  config = lib.mkIf (wayland.enable && cfg.enable) {
    home.packages = with pkgs; [
      wl-clipboard
    ];

    services.cliphist = {
      enable = true;
      allowImages = true;
      clipboardPackage = pkgs.wl-clipboard;
    };

    systemd.user.services.cliphist-clean = {
      Unit = {
        Description = "Clear cliphist history";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.cliphist}/bin/cliphist wipe";
      };
    };

    systemd.user.timers.cliphist-clean = {
      Unit = {
        Description = "Run cliphist-clean every 30 minutes";
      };

      Timer = {
        OnBootSec = "5min";
        OnUnitActiveSec = "30min";
        Persistent = false;
      };

      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
}
