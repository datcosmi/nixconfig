{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.vpn.proton-vpn;
in {
  options.my.features.desktop.apps.vpn.proton-vpn.enable = lib.mkEnableOption "Enable Proton VPN app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      proton-vpn
    ];
  };
}
