{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.dev.git;
  ssh = config.my.features.ssh;
in {
  options.my.features.dev.git.enable = lib.mkEnableOption "Install git and it's necessary packages";

  config = lib.mkIf cfg.enable {
    programs.git.enable = true;
    programs.lazygit.enable = true;

    programs.ssh.settings = lib.mkIf ssh.enable {
      "github.com" = {
        HostName = "github.com";
        User = "git";
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/github";
      };
    };
  };
}
