{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.tealdeer;
in {
  options.my.features.shell.tealdeer.enable = lib.mkEnableOption "Enable tealdeer shell tool";

  config = lib.mkIf cfg.enable {
    programs.tealdeer = {
      enable = true;

      settings = {
        updates = {
          auto_update = true;
        };
      };
    };
  };
}
