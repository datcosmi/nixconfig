{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.nh;
in {
  options.my.features.shell.nh.enable = lib.mkEnableOption "Enable nh cli";

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 10d --keep 10 --optimise";
        dates = "weekly";
      };
      flake = "${config.home.homeDirectory}/.nixconfig";
    };
  };
}
