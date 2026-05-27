{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = osConfig.my.features.desktop.niri;
in {
  imports = [./lock.nix];

  config = lib.mkIf cfg.enable {
    xdg.configFile."niri/config.kdl".text = lib.concatStringsSep "\n" [
      (builtins.readFile ./base.kdl)
      cfg.monitorsConfig
      cfg.inputsConfig
    ];

    my.features = {
      desktop = {
        launchers.rofi.enable = lib.mkDefault true;
        clipboard.cliphist.enable = lib.mkDefault true;
        wallpaper.awww.enable = lib.mkDefault true;
        fonts.enable = lib.mkDefault true;

        ui = {
          waybar.enable = lib.mkDefault true;
          # swaync.enable = lib.mkDefault true;
          swayosd.enable = lib.mkDefault true;
          # wleave.enable = lib.mkDefault true;
        };

        apps = {
          file-managers.nautilus.enable = lib.mkDefault true;
          media.loupe.enable = lib.mkDefault true;
          media.localsend.enable = lib.mkDefault true;

          tui.enable = lib.mkDefault true;
        };
      };

      custom = {
        niriLockSuspend.enable = lib.mkDefault false;
      };

      terminal.alacritty.enable = lib.mkDefault true;
      shell.bash.enable = lib.mkDefault true;
    };
  };
}
