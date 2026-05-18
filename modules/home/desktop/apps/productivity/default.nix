{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.productivity;
in {
  options.my.features.desktop.apps.productivity.enable = lib.mkEnableOption "Enable all productivity apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.productivity = {
      obsidian.enable = lib.mkDefault true;
      zathura.enable = lib.mkDefault true;
      libreoffice.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./obsidian.nix
    ./zathura.nix
    ./libreoffice.nix
  ];
}
