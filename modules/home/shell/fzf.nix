{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.fzf;
in {
  options.my.features.shell.fzf.enable = lib.mkEnableOption "Enable fzf shell tool";

  config = lib.mkIf cfg.enable {
    programs.fzf.enable = true;
  };
}
