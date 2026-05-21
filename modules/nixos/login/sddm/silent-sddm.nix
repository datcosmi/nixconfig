{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.my.features.system.login.sddm.silent-sddm;
in {
  imports = [inputs.silentSDDM.nixosModules.default];

  options.my.features.system.login.sddm.silent-sddm.enable = lib.mkEnableOption "Enable SilentSDDM Theme";

  config = lib.mkIf cfg.enable {
    programs.silentSDDM = {
      enable = true;
      theme = "catppuccin-mocha";
    };
  };
}
