{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.apps.pdf;
in {
  options.my.features.desktop.apps.pdf.enable = lib.mkEnableOption "Enable all pdf apps";

  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.pdf = {
      zathura.enable = lib.mkDefault true;
    };
  };

  imports = [
    ./zathura.nix
  ];
}
