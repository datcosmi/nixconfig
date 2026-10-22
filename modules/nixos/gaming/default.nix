{lib, ...}: {
  imports = [
    ./launchers.nix
    ./performance.nix
  ];

  options.my.features.gaming.enable = lib.mkEnableOption "Gaming setup: Steam with Proton-GE, Heroic, Gamescope, GameMode, MangoHud";
}
