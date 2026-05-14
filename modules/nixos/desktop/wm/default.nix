{lib, ...}: {
  imports = [
    ./niri
  ];

  options.my.features.wayland.enable = lib.mkEnableOption "Wayland session and related environment";
}
