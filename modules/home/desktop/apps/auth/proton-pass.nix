{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.auth.proton-pass;
in {
  options.my.features.desktop.apps.auth.proton-pass.enable = lib.mkEnableOption "Enable Proton Pass app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      proton-pass
    ];
  };
}
