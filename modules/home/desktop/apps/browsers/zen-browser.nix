{
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop.apps.browsers.zen-browser;

  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  extensions = [
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    # (extension "canvasblocker" "CanvasBlocker@kkapsner.de")
    (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me")
    (extension "darkreader" "addon@darkreader.org")
  ];
in {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options.my.features.desktop.apps.browsers.zen-browser.enable = lib.mkEnableOption "Enable Zen Browser";

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;

      policies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        DisablePocket = true;
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;

        HttpsOnlyMode = "force_enabled";

        DNSOverHTTPS = {
          Enabled = true;
          ProviderURL = "https://dns.quad9.net/dns-query";
          Fallback = true;
        };

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
        };

        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        ExtensionSettings = builtins.listToAttrs extensions;
      };

      profiles.suavicrema = {
        id = 0;
        isDefault = true;

        search = {
          force = true;
          default = "ddg";
        };

        settings = {
          # Enhanced tracking protection
          "browser.contentblocking.category" = "strict";
          "privacy.resistFingerprinting" = true;

          # Total Cookie Protection
          "network.cookie.cookieBehavior" = 5;

          # Telemetry not fully covered by the DisableTelemetry policy.
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # Crash reports
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        };
      };
    };
  };
}
