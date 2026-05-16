{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.tui;
in {
  options.my.features.desktop.apps.tui.enable = lib.mkEnableOption "Enable all tui apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.tui = {
      btop.enable = lib.mkDefault true;
      yazi.enable = lib.mkDefault true;
      impala.enable = lib.mkDefault true;
      bluetui.enable = lib.mkDefault true;
      wiremix.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./btop.nix
    ./yazi.nix
    ./impala.nix
    ./bluetui.nix
    ./wiremix.nix
  ];
}
