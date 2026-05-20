{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.fastfetch;
in {
  options.my.features.shell.fastfetch.enable = lib.mkEnableOption "Enable fastfetch shell";

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
    };
  };
}
