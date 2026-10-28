{
  osConfig,
  lib,
  ...
}: let
  os = osConfig.my.features.theme;
  d = lib.mkDefault;
in {
  my.features.theme = {
    palette = d os.palette;
    catppuccin.flavor = d os.catppuccin.flavor;
    catppuccin.accent = d os.catppuccin.accent;
    gtk = d os.gtk;
    cursor = d os.cursor;
    dark = d os.dark;
  };
}
