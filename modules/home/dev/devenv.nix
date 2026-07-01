{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.dev.devenv;
in {
  options.my.features.dev.devenv.enable = lib.mkEnableOption "Install devenv";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      devenv
    ];
  };
}
