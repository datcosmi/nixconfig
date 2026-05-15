{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.browsers;
in {
  imports = [
    ./vivaldi.nix
    ./librewolf.nix
  ];

  options.my.features.browsers.enable = lib.mkEnableOption "Enable browser apps";

  config = lib.mkIf cfg.enable {
    my.features.browsers = {
      librewolf.enable = lib.mkDefault true;
      vivaldi.enable = lib.mkDefault true;
    };
  };
}
