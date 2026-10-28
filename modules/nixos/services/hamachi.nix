{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.system.services.hamachi;
  desktop = config.my.features.desktop;
in {
  options.my.features.system.services.hamachi.enable = lib.mkEnableOption "Enable Hamachi support";

  config = lib.mkIf cfg.enable {
    # Unstable's glibc 2.44 segfaults hamachid in the dynamic loader;
    # use the stable build (with its own glibc) until that's resolved.
    nixpkgs.overlays = [
      (final: prev: {
        logmein-hamachi = final.stable.logmein-hamachi;
      })
    ];

    services.logmein-hamachi.enable = true;

    programs.haguichi.enable = desktop.enable;
  };
}
