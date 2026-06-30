{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.services.hamachi;
  desktop = config.my.features.desktop;
in {
  options.my.features.system.services.hamachi.enable = lib.mkEnableOption "Enable Hamachi support";

  config = lib.mkIf cfg.enable {
    services.logmein-hamachi.enable = true;

    programs.haguichi.enable = desktop.enable;
  };
}
