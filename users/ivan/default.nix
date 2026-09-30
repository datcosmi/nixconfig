{
  pkgs,
  lib,
  helpers,
  ...
}: {
  imports = [
    (helpers.mkUser {
      username = "ivan";
      description = "Ivan";
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    })
  ];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
