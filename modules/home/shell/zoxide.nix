{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.zoxide;
  shell = config.my.features.shell;
in {
  options.my.features.shell.zoxide.enable = lib.mkEnableOption "Enable zoxide shell tool";

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;

      enableBashIntegration = shell.bash.enable;
      enableZshIntegration = shell.zsh.enable;
      enableFishIntegration = shell.fish.enable;
    };
  };
}
