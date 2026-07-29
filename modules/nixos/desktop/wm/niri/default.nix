{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.features.desktop.niri;
in {
  options.my.features.desktop.niri = {
    enable = lib.mkEnableOption "Niri window manager";

    monitorsConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = ''
        Host-specific niri settings fragment: outputs, workspaces, and the
        window-rules that route apps to a given output/workspace.
      '';
    };
    inputsConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Host-specific niri settings fragment: the `input` block.";
    };
  };

  config = lib.mkIf cfg.enable {
    my.features.wayland.enable = lib.mkForce true;
    my.features.system.services.security.polkitAgent.enable = lib.mkForce true;
    my.features.system.services.security.gnomeKeyring.enable = lib.mkDefault true;

    programs.niri = {
      enable = true;
    };

    services.displayManager.sessionPackages = [pkgs.niri];

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
