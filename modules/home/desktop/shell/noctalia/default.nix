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
        general = {
          dimmerOpacity = 0.2;
          showScreenCorners = false;
          forceBlackScreenCorners = false;
          scaleRatio = 1;
          radiusRatio = 1;
          iRadiusRatio = 1;
          boxRadiusRatio = 1;
          screenRadiusRatio = 1;
          animationSpeed = 1;
          animationDisabled = false;
          compactLockScreen = false;
          lockScreenAnimations = true;
          lockOnSuspend = true;
          showSessionButtonsOnLockScreen = true;
          showHibernateOnLockScreen = false;
          enableLockScreenMediaControls = false;
          enableShadows = true;
          enableBlurBehind = true;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          language = "";
          allowPanelsOnScreenWithoutBar = true;
          showChangelogOnStartup = true;
          telemetryEnabled = false;
          enableLockScreenCountdown = true;
          lockScreenCountdownDuration = 10000;
          autoStartAuth = false;
          allowPasswordWithFprintd = false;
          clockStyle = "analog";
          passwordChars = false;
          lockScreenMonitors = [];
          lockScreenBlur = 0.9;
          lockScreenTint = 0.3;
          keybinds = {
            keyUp = [
              "Up"
            ];
            keyDown = [
              "Down"
            ];
            keyLeft = [
              "Left"
            ];
            keyRight = [
              "Right"
            ];
            keyEnter = [
              "Return"
              "Enter"
            ];
            keyEscape = [
              "Esc"
            ];
            keyRemove = [
              "Del"
            ];
          };
          reverseScroll = false;
          smoothScrollEnabled = true;
        };
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
                hideWhenIdle = true;
                width = 100;
              }
            ];

            center = [
              {id = "NotificationHistory";}
              {
                id = "Clock";
                useCustomFont = true;
                customFont = "Lexend Exa SemiBold";
                tooltipFormat = "hh:mm AP dddd, MMM dd yyyy";
              }
              {id = "Settings";}
            ];

            right = [
              {
                id = "Tray";
                colorizeIcons = false;
              }
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
          screenOffCommand = "";
          lockCommand = "";
          suspendCommand = "";
          resumeScreenOffCommand = "";
          resumeLockCommand = "";
          resumeSuspendCommand = "";
          customCommands = "[]";
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

        osd = {
          enabled = true;
          location = "bottom";
          autoHideMs = 2000;
          overlayLayer = true;
          backgroundOpacity = 1;
          enabledTypes = [
            0
            1
            2
          ];
          monitors = [];
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

        systemMonitor = {
          externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        };

        location = {
          weatherEnabled = false;
          useFahrenheit = false;
          use12hourFormat = true;
          showWeekNumberInCalendar = false;
          showCalendarEvents = true;
          analogClockInCalendar = true;
          autoLocate = false;
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

        brightness = {
          brightnessStep = 5;
          enforceMinimum = true;
          enableDdcSupport = true;
          backlightDeviceMappings = [];
        };
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
