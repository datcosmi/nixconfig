{
  pkgs,
  lib,
  ...
}: {
  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://noctalia.cachix.org"
      "https://niri.cachix.org"
    ];
    trusted-substituters = [
      "https://cache.nixos.org/"
      "https://noctalia.cachix.org"
      "https://niri.cachix.org"
    ];
    trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };
}
