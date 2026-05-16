{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.auth.ente-auth;
in {
  options.my.features.desktop.apps.auth.ente-auth.enable = lib.mkEnableOption "Enable Ente Auth app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ente-auth
    ];
  };
}
