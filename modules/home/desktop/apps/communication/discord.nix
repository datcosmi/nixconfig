{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.communication.discord;
in {
  options.my.features.desktop.apps.communication.discord.enable = lib.mkEnableOption "Enable discord app";

  config = lib.mkIf cfg.enable {
    programs.discord = {
      enable = true;
      package = pkgs.discord-canary;
    };
  };
}
