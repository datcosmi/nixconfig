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

    systemd.tmpfiles.rules =
      lib.concatMap (
        user: let
          avatarPath = ../../../users/${user}/avatar.png;
        in
          lib.optionals (builtins.pathExists avatarPath) [
            "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
            "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${avatarPath}"
          ]
      )
      config.my.users;
  };
}
