{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.terminal.kitty;
in {
  options.my.features.terminal.kitty.enable = lib.mkEnableOption "Enable kitty terminal";

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };
  };
}
