{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.dev.git;
  ssh = config.my.features.ssh;
in {
  options.my.features.dev.git.enable = lib.mkEnableOption "Enable git and related libraries & add github to ssh known hosts";

  config = lib.mkIf cfg.enable {
    programs.git.enable = true;

    programs.ssh.settings = lib.mkIf ssh.enable {
      "github.com" = {
        HostName = "github.com";
        User = "git";
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/github";
      };
    };

    my.features.dev.git = {
      lazygit.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./lazygit.nix
  ];
}
