{pkgs, ...}: {
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;

  security.polkit.enable = true;

  programs.dconf.enable = true;

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  services.upower.enable = true;

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  powerManagement.enable = true;

  systemd.user.extraConfig = ''
    DefaultMemoryHigh=12G
  '';
}
