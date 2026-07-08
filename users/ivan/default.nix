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
        "video"
        "audio"
        "input"
        "networkmanager"
        "bluetooth"
        "i2c"
        "docker"
        "uinput"
      ];
    })
  ];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  nix.settings.trusted-users = lib.mkAfter ["ivan"];
}
