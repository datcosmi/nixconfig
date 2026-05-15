{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.terminal;
in {
  imports = [
    ./kitty.nix
    ./ghostty.nix
  ];

  options.my.features.terminal.enable = lib.mkEnableOption "Enable all terminal emulators";

  config = lib.mkIf cfg.enable {
    my.features.terminal.kitty.enable = lib.mkDefault true;
    my.features.terminal.ghostty.enable = lib.mkDefault true;
  };
}
