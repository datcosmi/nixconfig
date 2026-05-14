{
  config,
  lib,
  ...
}: let
  cfg = config.my.hardware.ssd;
in {
  options.my.hardware.ssd = lib.mkEnableOption "SSD fstrim trimming";

  config = lib.mkIf cfg {
    services.fstrim = {
      enable = true;
      interval = "weekly";
    };
  };
}
