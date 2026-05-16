{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.bash;
in {
  options.my.features.shell.bash.enable = lib.mkEnableOption "Enable bash shell tool";

  config = lib.mkIf cfg.enable {
    programs.bash.enable = true;
  };
}
