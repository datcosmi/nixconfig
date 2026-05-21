{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.login.sddm;
in {
  options.my.features.system.login.sddm.enable = lib.mkEnableOption "Enable SDDM Display Manager";

  config = cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  imports = [
    ./silent-sddm.nix
  ];
}
