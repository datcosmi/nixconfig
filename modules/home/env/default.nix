{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = osConfig.my.features.wayland;
  bat = config.my.features.shell.bat;
in {
  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      PAGER = lib.mkIf bat.enable "bat";
    };
  };
}
