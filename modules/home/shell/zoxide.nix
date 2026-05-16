{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.zoxide;
in {
  options.my.features.shell.zoxide.enable = lib.mkEnableOption "Enable zoxide shell tool";

  config = lib.mkIf cfg.enable {
    programs.zoxide.enable = true;
  };
}
