{
  lib,
  config,
  ...
}: let
  spec = config.my.features.theme.cursorSpec;
in {
  config = lib.mkIf (spec != null) {
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      inherit (spec) name package size;
    };
  };
}
