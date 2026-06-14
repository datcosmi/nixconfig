{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.starship;
  shell = config.my.features.shell;
in {
  options.my.features.shell.starship.enable = lib.mkEnableOption "Enable starship shell";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;

      enableBashIntegration = shell.bash.enable;
      enableZshIntegration = shell.zsh.enable;
      enableFishIntegration = shell.fish.enable;
    };
  };
}
