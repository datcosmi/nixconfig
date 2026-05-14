{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.printing;
in {
  options.my.features.system.printing.enable = lib.mkEnableOption "Printing support";

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;

    environment.systemPackages = with pkgs; [
      system-config-printer
    ];
  };
}
