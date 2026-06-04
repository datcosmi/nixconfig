{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.my.features.desktop.shell.noctalia;
  wallpaper = config.my.features.theme.wallpaper;
  noctaliaShell = config.programs.noctalia-shell.package;
  lockCmd = "${noctaliaShell}/bin/noctalia-shell ipc call lockScreen lock &";
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.my.features.desktop.shell.noctalia.enable = lib.mkEnableOption "Enable Noctalia Shell";

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
    };

    # home.file.".cache/noctalia/wallpapers.json" = {
    #   text = builtins.toJSON {
    #     defaultWallpaper = "${wallpaper}";
    #   };
    # };

    services.swayidle = {
      enable = true;
      systemdTargets = ["graphical-session.target"];
      events = {
        lock = lockCmd;
        before-sleep = lockCmd;
      };
    };
  };
}
