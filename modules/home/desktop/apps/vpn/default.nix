{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.vpn;
in {
  options.my.features.desktop.apps.vpn.enable = lib.mkEnableOption "Enable all vpn apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.vpn = {
      proton-vpn.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./proton
  ];
}
