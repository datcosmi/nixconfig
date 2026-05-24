{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.desktop.noctalia;
in {
  config = lib.mkIf.cfg.enable {
    nixConfig = {
      extra-substituters = ["https://noctalia.cachix.org"];
      extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
    };
  };
}
