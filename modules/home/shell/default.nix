{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.shell;
in {
  options.my.features.shell.enable = lib.mkEnableOption "Enable all shell tools";

  config = lib.mkIf cfg.enable {
    my.features.shell = {
      starship.enable = lib.mkDefault true;
      fastfetch.enable = lib.mkDefault true;
      bash.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
      bat.enable = lib.mkDefault true;
      eza.enable = lib.mkDefault true;
      fzf.enable = lib.mkDefault true;
      ripgrep.enable = lib.mkDefault true;
      jq.enable = lib.mkDefault true;
      fd.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      tealdeer.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./starship.nix
    ./fastfetch.nix
    ./zsh
    ./bash.nix
    ./bat.nix
    ./eza.nix
    ./fzf.nix
    ./ripgrep.nix
    ./jq.nix
    ./fd.nix
    ./zoxide.nix
    ./tealdeer.nix
  ];
}
