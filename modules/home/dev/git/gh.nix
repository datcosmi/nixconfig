{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.dev.git.gh;
in {
  options.my.features.dev.git.gh.enable = lib.mkEnableOption "Enable gh cli";

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
