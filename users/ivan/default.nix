{
  lib,
  pkgs,
  ...
}: {
  users.users.ivan = {
    isNormalUser = true;
    description = "Ivan";
    shell = pkgs.zsh;

    home = "/home/ivan";
    createHome = true;

    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
      "networkmanager"
      "bluetooth"
    ];
  };

  programs.zsh.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  nix.settings.trusted-users = lib.mkAfter ["ivan"];
}
