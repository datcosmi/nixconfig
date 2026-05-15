{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.ssh;
in {
  options.my.features.ssh.enable = lib.mkEnableOption "SSH service";

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
    };

    services.gpg-agent.enable = true;

    programs.ssh.matchBlocks = {
      "github.com" = {
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/github";
      };
    };
  };
}
