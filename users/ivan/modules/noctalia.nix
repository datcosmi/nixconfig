{
  config,
  lib,
  pkgs,
  inputs,
  hostname,
  ...
}: let
  cfg = config.my.features.desktop.shell.noctalia;
  c = config.my.features.theme.colors;

  isLaptop = hostname == "mandarina";

  widgetSpacing =
    if isLaptop
    then 1
    else 3;
  brightnessStep =
    if isLaptop
    then 5
    else 10;
  visualizerWidth =
    if isLaptop
    then 100
    else 130;
in {
  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      settings = {
        settingsVersion = 59;
        general = {
          dimmerOpacity = 0.2;
          showScreenCorners = true;
          forceBlackScreenCorners = true;
          scaleRatio = 1;
          radiusRatio = 1;
          iRadiusRatio = 1;
          boxRadiusRatio = 1;
          screenRadiusRatio = 0.73;
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
          shadowDirection = "center";
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
          density = "comfortable";
          fontScale = 1;
          frameThickness = 5;
          frameRadius = 13;
          showCapsule = false;
          widgetSpacing = widgetSpacing;
          contentPadding = 0;
          enableExclusionZoneInset = false;

          widgets = {
            left =
              [
                {id = "SystemMonitor";}
              ]
              ++ lib.optionals (!isLaptop) [
                {
                  id = "ActiveWindow";
                  colorizeIcons = true;
                }
              ]
              ++ [
                {
                  id = "Workspace";
                  hideUnoccupied = false;
                  pillSize = 0.53;
                  labelMode = "none";
                }
                {id = "MediaMini";}
                {
                  id = "AudioVisualizer";
                  hideWhenIdle = false;
                  width = visualizerWidth;
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

            right =
              [
                {
                  id = "Tray";
                  colorizeIcons = false;
                }
              ]
              ++ lib.optionals (!isLaptop) [
                {id = "KeepAwake";}
              ]
              ++ [
                {id = "plugin:mirror-mirror";}
                {id = "Volume";}
                {id = "plugin:network-manager-vpn";}
                {id = "Bluetooth";}
                {id = "Network";}
              ]
              ++ lib.optionals isLaptop [
                {id = "Battery";}
              ]
              ++ [
                {id = "KeyboardLayout";}
                {id = "SessionMenu";}
              ];
          };
        };

        idle = {
          enabled = true;
          screenOffTimeout = 600;
          lockTimeout = 660;
          suspendTimeout = 1200;
          fadeDuration = 5;
        };

        ui = {
          fontDefault = "Lexend";
        };

        wallpaper = {
          overviewEnabled = true;
          overviewBlur = 0.4;
          overviewTint = 0.6;
        };

        plugins = {
          autoUpdate = false;
          notifyUpdates = false;
        };

        dock = {
          enabled = true;
          position = "bottom";
        };

        audio = {
          volumeStep = 5;
          volumeOverdrive = false;
          spectrumFrameRate = 30;
          visualizerType = "linear";
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
            3
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
          brightnessStep = brightnessStep;
          enforceMinimum = isLaptop;
          enableDdcSupport = true;
          backlightDeviceMappings = [];
        };
      };

      colors = {
        mPrimary = c.pink;
        mOnPrimary = c.base;
        mSecondary = c.lavender;
        mOnSecondary = c.base;
        mTertiary = c.mauve;
        mOnTertiary = c.base;
        mError = c.red;
        mOnError = c.base;
        mSurface = c.base;
        mOnSurface = c.text;
        mSurfaceVariant = c.surface0;
        mOnSurfaceVariant = c.subtext0;
        mOutline = c.surface2;
        mHover = c.surface1;
        mOnHover = c.text;
        mShadow = c.crust;
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
          mirror-mirror = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          # nvibrant = {
          #   enabled = true;
          #   sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          # };
        };

        version = 2;
      };
    };
  };
}
