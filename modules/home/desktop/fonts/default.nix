{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.fonts;
in {
  options.my.features.desktop.fonts.enable = lib.mkEnableOption "Enable all desktop fonts";

  config = lib.mkIf cfg.enable {
    my.features.desktop.fonts = {
      regular.enable = lib.mkDefault true;
      nerd-fonts.enable = lib.mkDefault true;
      emoji.enable = lib.mkDefault true;
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["DejaVu Serif"];
        sansSerif = ["Lexend"];
        monospace = ["JetBrains Mono"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  imports = [
    ./regular.nix
    ./nerdfonts.nix
    ./emoji.nix
  ];
}
