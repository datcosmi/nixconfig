{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.starship;
in {
  options.my.features.shell.starship.enable = lib.mkEnableOption "Enable starship shell";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
    };
  };
}
