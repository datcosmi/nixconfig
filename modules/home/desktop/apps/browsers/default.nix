{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.browsers;
in {
  imports = [
    ./vivaldi.nix
    ./librewolf.nix
  ];

  options.my.features.desktop.apps.browsers.enable = lib.mkEnableOption "Enable browser apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.browsers = {
      librewolf.enable = lib.mkDefault true;
      vivaldi.enable = lib.mkDefault true;
    };
  };
}
