{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.my.features.system.login.sddm.theme.silentSDDM;
in {
  imports = [inputs.silentSDDM.nixosModules.default];

  options.my.features.system.login.sddm.theme.silentSDDM = lib.mkEnableOption "Enable SilentSDDM Theme";

  config = lib.mkIf cfg {
    programs.silentSDDM = {
      enable = true;
    };
  };
}
