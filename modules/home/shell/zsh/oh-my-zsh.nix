{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.zsh.oh-my-zsh;
in {
  options.my.features.shell.zsh.oh-my-zsh.enable = lib.mkEnableOption "Enable oh-my-zsh plugins";

  config = lib.mkIf cfg.enable {
    programs.zsh.oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "dirhistory"
        "history"
        "ssh-agent"
      ];
      theme = "robbyrussell";
    };
  };
}
