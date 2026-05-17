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
    my.features.desktop.apps.vpn.proton-vpn = {
      gui.enable = lib.mkDefault true;
      cli.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./cli.nix
    ./gui.nix
  ];
}
