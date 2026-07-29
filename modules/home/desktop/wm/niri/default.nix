{
  config,
  lib,
  osConfig,
  ...
}: let
  host = osConfig.my.features.desktop.niri;
  user = config.my.features.desktop.niri;

  mergeNiriSettings = fragments: let
    merged = lib.foldl' lib.recursiveUpdate {} fragments;
    children = lib.concatMap (f: f._children or []) fragments;
  in
    merged // lib.optionalAttrs (children != []) {_children = children;};
in {
  imports = [./lock.nix];

  options.my.features.desktop.niri.baseConfig = lib.mkOption {
    type = lib.types.attrs;
    default = {};
    description = ''
      User-specific niri settings, shared across every host, in
      `wayland.windowManager.niri.settings` format. Set this from
      users/<user>/home.nix, e.g.:
        my.features.desktop.niri.baseConfig = import ../../modules/home/niri/base-settings.nix;
    '';
  };

  config = lib.mkIf host.enable {
    wayland.windowManager.niri = {
      enable = true;
      settings = mergeNiriSettings [
        user.baseConfig
        host.monitorsConfig
        host.inputsConfig
      ];
    };

    my.features = {
      desktop = {
        launchers.rofi.enable = lib.mkDefault true;
        clipboard.cliphist.enable = lib.mkDefault true;
        wallpaper.awww.enable = lib.mkDefault true;
        fonts.enable = lib.mkDefault true;
        ui = {
          waybar.enable = lib.mkDefault true;
          swaync.enable = lib.mkDefault true;
          swayosd.enable = lib.mkDefault true;
          wleave.enable = lib.mkDefault true;
        };
        apps = {
          file-managers.nautilus.enable = lib.mkDefault true;
          media.loupe.enable = lib.mkDefault true;
          media.localsend.enable = lib.mkDefault true;
          tui.enable = lib.mkDefault true;
        };
        custom = {
          niriLockSuspend.enable = lib.mkDefault true;
        };
      };
      terminal.alacritty.enable = lib.mkDefault true;
      shell.bash.enable = lib.mkDefault true;
    };
  };
}
