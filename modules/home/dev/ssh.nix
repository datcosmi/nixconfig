{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.ssh;
in {
  options.my.features.ssh.enable = lib.mkEnableOption "SSH service";

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
    };

    services.gpg-agent.enable = true;
    services.ssh-agent.enable = true;
  };
}
