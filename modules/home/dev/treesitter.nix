{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.dev.treesitter;
in {
  options.my.features.dev.treesitter.enable = lib.mkEnableOption "Install treesitter and it's necessary packages";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tree-sitter
      gcc
    ];
  };
}
