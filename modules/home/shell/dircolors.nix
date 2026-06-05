{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.dircolors;
in {
  options.my.features.shell.dircolors.enable = lib.mkEnableOption "Enable dircolors colorized output";

  config = lib.mkIf cfg.enable {
    programs.dircolors.enable = true;
  };
}
