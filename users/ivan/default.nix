{
  pkgs,
  lib,
  ...
}: {
  users.users.ivan = {
    isNormalUser = true;
    description = "Ivan";
    shell = pkgs.fish;

    home = "/home/ivan";
    createHome = true;

    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
      "networkmanager"
      "bluetooth"
      "i2c"
    ];
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  nix.settings.trusted-users = lib.mkAfter ["ivan"];
}
