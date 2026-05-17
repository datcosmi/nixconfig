{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.vpn.proton-vpn.cli;
in {
  options.my.features.desktop.apps.vpn.proton-vpn.cli.enable = lib.mkEnableOption "Enable Proton VPN CLI";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      proton-vpn-cli
    ];
  };
}
