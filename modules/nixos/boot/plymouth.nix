{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.boot.plymouth;
in {
  options.my.features.boot.plymouth.enable = lib.mkEnableOption "Enable Plymouth on boot";

  config = lib.mkIf cfg.enable {
    boot = {
      plymouth = {
        enable = true;
        theme = "cuts_alt";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = ["cuts_alt"];
          })
        ];
      };

      initrd.systemd.enable = true;

      # Enable "Silent boot"
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
      ];
    };
  };
}
