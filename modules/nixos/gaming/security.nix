{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.gaming.security;
in {
  options.my.features.gaming.security = {
    enable = lib.mkEnableOption "Real-time priority and memory lock limits for gaming";
  };

  config = lib.mkIf cfg.enable {
    security.pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "soft";
        value = "70";
      }
      {
        domain = "@users";
        item = "rtprio";
        type = "hard";
        value = "99";
      }
      {
        domain = "@users";
        item = "memlock";
        type = "soft";
        value = "524288";
      }
      {
        domain = "@users";
        item = "memlock";
        type = "hard";
        value = "524288";
      }
    ];
  };
}
