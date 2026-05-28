{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.my.features.desktop.shell.noctalia;
  wallpaper = config.my.features.theme.wallpaper;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.my.features.desktop.shell.noctalia.enable = lib.mkEnableOption "Enable Noctalia Shell";

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;

      colors = {
        mPrimary = "#f5c2e7";
        mOnPrimary = "#1e1e2e";
        mSecondary = "#b4befe";
        mOnSecondary = "#1e1e2e";
        mTertiary = "#cba6f7";
        mOnTertiary = "#1e1e2e";
        mError = "#f38ba8";
        mOnError = "#1e1e2e";
        mSurface = "#1e1e2e";
        mOnSurface = "#cdd6f4";
        mSurfaceVariant = "#313244";
        mOnSurfaceVariant = "#a6adc8";
        mOutline = "#585b70";
        mHover = "#45475a";
        mOnHover = "#cdd6f4";
        mShadow = "#11111b";
      };
    };

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "${wallpaper}";
      };
    };
  };
}
