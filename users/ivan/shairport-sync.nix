{ pkgs, ... }:
let
  shairport = pkgs.shairport-sync-mpris;
  configFile = pkgs.writeText "shairport-sync.conf" ''
    general = {
      name = "%H";
      output_backend = "pipewire";
      mdns_backend = "avahi";
      mpris_service_bus = "session";
      dbus_service_bus = "session";
      volume_range_db = 60;
    };

    metadata = {
      enabled = "yes";
      include_cover_art = "yes";
    };

    diagnostics = {
      log_verbosity = 1;
    };
  '';
in
{
  home.packages = [ shairport pkgs.playerctl ];

  systemd.user.services.shairport-sync = {
    Unit = {
      Description = "Shairport Sync AirPlay receiver with MPRIS";
      After = [ "pipewire-pulse.service" "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      ExecStart = "${shairport}/bin/shairport-sync --configfile=${configFile}";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
