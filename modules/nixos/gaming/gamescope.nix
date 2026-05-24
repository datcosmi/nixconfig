{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.gaming.gamescope;
in {
  options.my.features.gaming.gamescope = {
    enable = lib.mkEnableOption "Gamescope compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    environment.systemPackages = with pkgs; [
      gamescope
    ];
  };
}
