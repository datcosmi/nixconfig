{
  config,
  lib,
  osConfig,
  pkgs,
  inputs,
  ...
}: let
  cfg = osConfig.my.features.desktop.noctalia;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
    };
  };
}
