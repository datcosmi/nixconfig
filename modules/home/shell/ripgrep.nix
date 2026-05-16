{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.ripgrep;
in {
  options.my.features.shell.ripgrep.enable = lib.mkEnableOption "Enable ripgrep shell tool";

  config = lib.mkIf cfg.enable {
    programs.ripgrep.enable = true;
  };
}
