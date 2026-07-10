{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.niri;
in {
  imports = [
    inputs.niri.nixosModules.niri
  ];

  options.my.features.desktop.niri = {
    enable = lib.mkEnableOption "Niri window manager";

    monitorsConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Host-specific KDL monitor configuration";
    };

    inputsConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Host-specific KDL input device configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    my.features.wayland.enable = lib.mkForce true;
    my.features.system.services.security.polkitAgent.enable = lib.mkForce true;
    my.features.system.services.security.gnomeKeyring.enable = lib.mkDefault true;

    nixpkgs.overlays = [inputs.niri.overlays.niri];

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    services.displayManager.sessionPackages = [pkgs.niri-unstable];

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      alacritty
      libnotify
      libappindicator
      libayatana-appindicator
    ];

    environment.etc."wayland-sessions/niri.desktop".text = ''
      [Desktop Entry]
      Name=Niri
      Comment=Scrollable-tiling Wayland compositor
      Exec=niri-session
      Type=Application
      DesktopNames=niri
    '';
  };
}
