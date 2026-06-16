{
  config,
  hostname,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.ssh;
in {
  config = lib.mkIf cfg.enable {
    programs.ssh.settings = lib.mkIf (hostname != "mandarina") {
      "mandarina" = {
        HostName = "mandarina.local";
        User = "ivan";
        IdentityFile = "~/.ssh/mandarina";
        AddKeysToAgent = "yes";
      };
    };
  };
}
