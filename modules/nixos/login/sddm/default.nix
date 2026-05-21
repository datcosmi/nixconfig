{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.login.sddm;
  wayland = config.my.features.wayland.enable;
in {
  options.my.features.system.login.sddm.enable = lib.mkEnableOption "Enable SDDM Display Manager";

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland = lib.mkIf wayland {
        enable = lib.mkForce true;
      };
    };
  };

  imports = [
    ./silent-sddm.nix
  ];
}
