{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.niri;
in {
  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        substituters = [
          "https://niri.cachix.org"
        ];
        trusted-public-keys = [
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        ];
      };
    };
  };
}
