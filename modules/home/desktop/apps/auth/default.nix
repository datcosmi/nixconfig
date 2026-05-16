{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.auth;
in {
  options.my.features.desktop.apps.auth.enable = lib.mkEnableOption "Enable all auth apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.auth = {
      proton-pass.enable = lib.mkDefault true;
      ente-auth.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./proton-pass.nix
    ./ente-auth.nix
  ];
}
