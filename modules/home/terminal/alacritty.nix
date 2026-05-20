{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.terminal.alacritty;
in {
  options.my.features.terminal.alacritty.enable = lib.mkEnableOption "Enable alacritty terminal";

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
    };
  };
}
