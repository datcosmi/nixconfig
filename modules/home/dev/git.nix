{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.dev.git;
in {
  options.my.features.dev.git.enable = lib.mkEnableOption "Install git and it's necessary packages";

  config = lib.mkIf cfg.enable {
    programs.git.enable = true;
    programs.lazygit.enable = true;
  };
}
