{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.eza;
in {
  options.my.features.shell.eza.enable = lib.mkEnableOption "Enable eza shell tool";

  config = lib.mkIf cfg.enable {
    programs.eza.enable = true;
  };
}
