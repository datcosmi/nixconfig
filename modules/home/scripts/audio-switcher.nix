{pkgs, ...}: let
  toggle-audio-output = pkgs.writeShellApplication {
    name = "toggle-audio-output";
    runtimeInputs = [
      pkgs.python3
      pkgs.wireplumber
      pkgs.rofi
    ];
    text = ''
      python3 ${./toggle-audio-output.py} "$@"
    '';
  };
in {
  home.packages = [toggle-audio-output];
}
