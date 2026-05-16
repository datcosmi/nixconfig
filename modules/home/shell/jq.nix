{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.jq;
in {
  options.my.features.shell.jq.enable = lib.mkEnableOption "Enable jq shell tool";

  config = lib.mkIf cfg.enable {
    programs.jq.enable = true;
  };
}
