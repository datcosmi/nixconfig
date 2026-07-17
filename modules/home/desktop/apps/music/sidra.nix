{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.music.sidra;
  system = pkgs.stdenv.hostPlatform.system;
in {
  options.my.features.desktop.apps.music.sidra.enable = lib.mkEnableOption "Enable Sidra app";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.sidra.packages.${system}.default
    ];
  };
}
