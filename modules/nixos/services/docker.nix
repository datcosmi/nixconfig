{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.services.docker;
in {
  options.my.features.system.services.docker.enable = lib.mkEnableOption "Enable Docker support";

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };

      daemon.settings = {
        userns-remap = "default";
        no-new-privileges = true;
      };
    };
  };
}
