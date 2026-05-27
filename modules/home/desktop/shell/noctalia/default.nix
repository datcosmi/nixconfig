{
  config,
  lib,
  osConfig,
  pkgs,
  inputs,
  ...
}: let
  cfg = osConfig.my.features.desktop.noctalia;
  wallpaper = config.my.features.theme.wallpaper;
  display = osConfig.my.hardware.display;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf cfg.enable {
    home.file.".face".source = ../../../../../users/ivan/avatar.png;

    programs.noctalia-shell = {
      enable = true;

      settings = {
        bar = {
          barType = "framed";
          position = "left";
          density = "spacious";
          fontScale = 1;
          frameThickness = 4;
          frameRaius = 13;
          showCapsule = false;

          widgets = {
            left = [
              {id = "SystemMonitor";}
              {
                id = "ActiveWindow";
                colorizeIcons = true;
              }
              {
                id = "Workspace";
                hideUnoccupied = false;
                pillSize = 0.53;
                labelMode = "none";
              }
              {id = "MediaMini";}
              {
                id = "AudioVisualizer";
                width = 100;
              }
            ];

            center = [
              {id = "Settings";}
              {
                id = "Clock";
                useCustomFont = true;
                customFont = "Lexend Exa SemiBold";
                tooltipFormat = "hh:mm AP dddd, MMM dd yyyy";
              }
              {id = "NotificationHistory";}
            ];

            right = [
              {id = "Tray";}
              {id = "KeepAwake";}
              {id = "Volume";}
              {id = "plugin:network-manager-vpn";}
              {id = "Network";}
              {id = "Bluetooth";}
              {id = "Battery";}
              {id = "Brightness";}
              {id = "SessionMenu";}
            ];
          };
        };

        idle = {
          enabled = false;
          screenOffTimeout = 600;
          lockTimeout = 660;
          suspendTimeout = 1800;
          fadeDuration = 5;
          # lockCommand = "${pkgs.hyprlock}/bin/hyprlock";
        };

        ui = {
          fontDefault = "Lexend";
        };

        dock = {
          enabled = true;
          position = "right";
        };

        audio = {
          volumeStep = 5;
          volumeOverdrive = false;
          spectrumFrameRate = 30;
          visualizerType = "mirrored";
          spectrumMirrored = true;
          volumeFeedback = false;
        };

        sessionMenu = {
          enableCountdown = true;
          countdownDuration = 10000;
          position = "center";
          showHeader = true;
          showKeybinds = true;
          largeButtonsStyle = true;
          largeButtonsLayout = "grid";
          powerOptions = [
            {
              action = "lock";
              enabled = true;
              keybind = "L";
              # command = "${pkgs.hyprlock}/bin/hyprlock";
            }
            {
              action = "suspend";
              enabled = true;
              keybind = "U";
            }
            {
              action = "reboot";
              enabled = true;
              keybind = "R";
            }
            {
              action = "logout";
              enabled = true;
              keybind = "E";
            }
            {
              action = "shutdown";
              enabled = true;
              keybind = "S";
            }
            {
              action = "rebootToUefi";
              enabled = true;
              keybind = "B";
            }
          ];
        };

        appLauncher = {
          enableClipboardHistory = true;
          autoPasteClipboard = false;
          enableClipPreview = true;
          clipboardWrapText = true;
          enableClipboardSmartIcons = true;
          enableClipboardChips = true;
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          position = "center";
          sortByMostUsed = true;
          viewMode = "list";
          showCategories = true;
          iconMode = "tabler";
          showIconBackground = false;
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          enableSessionSearch = true;
          ignoreMouseInput = false;
          overviewLayer = false;
          density = "default";
        };

        # brightness = lib.mkMerge [
        #   (lib.mkIf display.ddc {
        #     enable_ddcutil = true;
        #
        #     monitor = {
        #       "DP-1" = {
        #         backend = "ddcutil";
        #       };
        #
        #       "HDMI-A-1" = {
        #         backend = "ddcutil";
        #       };
        #     };
        #   })
        #
        #   (lib.mkIf display.internalBacklight {
        #     monitor = {
        #       "eDP-1" = {
        #         backend = "backlight";
        #       };
        #     };
        #   })
        # ];
      };

      colors = {
        mPrimary = "#f5c2e7";
        mOnPrimary = "#1e1e2e";
        mSecondary = "#b4befe";
        mOnSecondary = "#1e1e2e";
        mTertiary = "#cba6f7";
        mOnTertiary = "#1e1e2e";
        mError = "#f38ba8";
        mOnError = "#1e1e2e";
        mSurface = "#1e1e2e";
        mOnSurface = "#cdd6f4";
        mSurfaceVariant = "#313244";
        mOnSurfaceVariant = "#a6adc8";
        mOutline = "#585b70";
        mHover = "#45475a";
        mOnHover = "#cdd6f4";
        mShadow = "#11111b";
      };

      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];

        states = {
          network-manager-vpn = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };

        version = 2;
      };
    };

    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "${wallpaper}";
      };
    };
  };
}
