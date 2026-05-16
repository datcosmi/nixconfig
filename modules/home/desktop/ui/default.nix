{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.ui;
in {
  options.my.features.desktop.ui.enable = lib.mkEnableOption "Enable all desktop UI tools";

  config = lib.mkIf cfg.enable {
    my.features.desktop.ui = {
      waybar.enable = lib.mkDefault true;
      swaync.enable = lib.mkDefault true;
      swayosd.enable = lib.mkDefault true;
      wleave.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./swaync.nix
    ./waybar.nix
    ./wleave.nix
    ./swayosd.nix
  ];
}
