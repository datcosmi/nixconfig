{...}: {
  imports = [
    ./waybar-media-player.nix
    ./waybar-brightness.nix
    ./ddc-brightness.nixc
    ./audio-switcher.nix
    #./hypr-dnd-toggle.nix
    ./niri-dnd-toggle.nix
    ./awww-wallpaper.nix
    ./bluetooth-status.nix
  ];
}
