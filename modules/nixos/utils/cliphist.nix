{
  config,
  lib,
  ...
}: let
  userNames = lib.attrNames config.users.users;

  mkFs = user: {
    "/home/${user}/.local/share/cliphist" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["size=50M" "nodev" "nosuid" "noexec" "mode=700"];
    };
  };
in {
  config = lib.mkIf config.my.features.wayland.enable {
    fileSystems = lib.mkMerge (map mkFs userNames);
  };
}
