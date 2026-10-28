{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.apps.recording.obs-studio;
  theme = config.my.features.theme;
in {
  options.my.features.desktop.apps.recording.obs-studio.enable = lib.mkEnableOption "Enable obs-studio";

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      package = pkgs.symlinkJoin {
        name = "obs-studio-nvenc";
        paths = [pkgs.obs-studio];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/obs \
            --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
        '';
      };
    };

    catppuccin.obs.enable = theme.palette == "catppuccin";
  };
}
