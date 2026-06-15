{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.fzf;
  shell = config.my.features.shell;
in {
  options.my.features.shell.fzf.enable = lib.mkEnableOption "Enable fzf shell tool";

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;

      enableBashIntegration = shell.bash.enable;
      enableZshIntegration = shell.zsh.enable;
      enableFishIntegration = shell.fish.enable;
    };
  };
}
