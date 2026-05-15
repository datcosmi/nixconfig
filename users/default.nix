{lib, ...}: {
  options.my.users = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Normal human users on this host, used by modules that need to act per-user";
  };
}
