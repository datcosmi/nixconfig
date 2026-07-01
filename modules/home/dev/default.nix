{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.dev;
in {
  imports = [
    ./ssh.nix
    ./tmux.nix
    ./lsp.nix
    ./treesitter.nix
    ./git.nix
    ./devenv.nix
  ];

  options.my.features.dev.enable = lib.mkEnableOption "Developer tools";

  config = lib.mkIf cfg.enable {
    my.features = {
      ssh.enable = lib.mkDefault true;

      dev = {
        tmux.enable = lib.mkDefault true;
        lsp.enable = lib.mkDefault true;
        treesitter.enable = lib.mkDefault true;
        git.enable = lib.mkDefault true;
        devenv.enable = lib.mkDefault true;
      };
    };
  };
}
