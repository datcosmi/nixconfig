{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.communication;
in {
  options.my.features.desktop.apps.communication.enable = lib.mkEnableOption "Enable all communication apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.communication = {
      discord.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./discord.nix
  ];
}
