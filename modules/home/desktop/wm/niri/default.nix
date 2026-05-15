{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = osConfig.my.features.desktop.niri;
in {
  imports = [./lock.nix];

  config = lib.mkIf cfg.enable {
    xdg.configFile."niri/config.kdl".text = lib.concatStringsSep "\n" [
      (builtins.readFile ./base.kdl)
      cfg.monitorsConfig
      cfg.inputsConfig
    ];
  };
}
