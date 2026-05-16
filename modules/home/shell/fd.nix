{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.fd;
in {
  options.my.features.shell.fd.enable = lib.mkEnableOption "Enable fd shell tool";

  config = lib.mkIf cfg.enable {
    programs.fd.enable = true;
  };
}
