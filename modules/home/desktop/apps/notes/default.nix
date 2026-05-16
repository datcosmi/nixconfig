{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.notes;
in {
  options.my.features.desktop.apps.notes.enable = lib.mkEnableOption "Enable all notes apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.notes = {
      obsidian.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./obsidian.nix
  ];
}
