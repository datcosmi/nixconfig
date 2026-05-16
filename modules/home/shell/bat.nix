{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.bat;
in {
  options.my.features.shell.bat.enable = lib.mkEnableOption "Enable bat shell tool";

  config = lib.mkIf cfg.enable {
    programs.bat.enable = true;
  };
}
