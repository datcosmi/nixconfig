{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.system.networking.avahi;
in {
  options.my.features.system.networking.avahi.enable = lib.mkEnableOption "Avahi service";

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      ipv4 = true;
      ipv6 = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
      publish = {
        enable = true;
        domain = true;
        addresses = true;
        userServices = true;
      };
    };

    systemd.services.avahi-daemon = {
      partOf = lib.mkForce [];
    };

    systemd.services.avahi-daemon-resume = {
      description = "Restart Avahi mDNS/DNS-SD after system resume";
      wantedBy = ["post-resume.target"];
      after = [
        "post-resume.target"
        "network-online.target"
      ];
      wants = ["network-online.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
        ExecStart = "${pkgs.systemd}/bin/systemctl restart avahi-daemon.service";
        RemainAfterExit = false;
      };
    };

    services.avahi.allowInterfaces = ["enp5s0" "wlan0"];
  };
}
