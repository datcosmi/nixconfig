{lib, ...}: {
  imports = [
    ./niri
  ];

  options.my.features.wayland.enable = lib.mkEnableOption "Wayland session and related environment";
  options.my.features.desktop.noctalia.enable = lib.mkEnableOption "Enable Noctalia Shell";
}
