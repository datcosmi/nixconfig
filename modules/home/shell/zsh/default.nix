{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.zsh;
in {
  options.my.features.shell.zsh.enable = lib.mkEnableOption "Enable zsh & it's home manager configurations";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      defaultKeymap = "viins";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history.size = 10000;
      history.ignoreAllDups = true;
      history.path = "$HOME/.zsh_history";
    };

    programs.dircolors.enableZshIntegration = true;
  };

  imports = [
    ./oh-my-zsh.nix
  ];
}
