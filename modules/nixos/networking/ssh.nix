{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.networking.ssh;
in {
  options.my.features.system.networking.ssh.enable = lib.mkEnableOption "Ssh service";

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
