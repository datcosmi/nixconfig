{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.dev.git.gh;
in {
  config = lib.mkIf cfg.enable {
    programs.gh = {
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
