{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.boot.plymouth;
in {
  options.my.features.boot.plymouth.enable = lib.mkEnableOption "Enable Plymouth on boot";

  config = lib.mkIf cfg.enable {
    boot.plymouth.enable = true;
  };
}
