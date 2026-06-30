{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.services.docker;
in {
  options.my.features.system.services.docker.enable = lib.mkEnableOption "Enable Docker support";

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
  };
}
