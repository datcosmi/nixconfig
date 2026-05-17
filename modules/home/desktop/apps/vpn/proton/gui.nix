{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.vpn.proton-vpn.gui;
in {
  options.my.features.desktop.apps.vpn.proton-vpn.gui.enable = lib.mkEnableOption "Enable Proton VPN GUI app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      proton-vpn
    ];
  };
}
