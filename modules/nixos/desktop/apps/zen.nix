{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop.apps.zen-browser;
  system = pkgs.stdenv.hostPlatform.system;

  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = {
    # Privacy & Fingerprinting Resistance
    "privacy.resistFingerprinting" = false;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "privacy.trackingprotection.fingerprinting.enabled" = true;
    "privacy.trackingprotection.cryptomining.enabled" = true;
    "privacy.partition.network_state.ocsp_cache" = true;

    # Disable all telemetry
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.ping-centre.telemetry" = false;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.hybridContent.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.updatePing.enabled" = false;

    # Disable experiments & studies
    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";

    # Disable crash reports
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

    # Enhanced Tracking Protection - Strict
    "browser.contentblocking.category" = "strict";

    # Cookie & Site Data - Total Cookie Protection
    "network.cookie.cookieBehavior" = 5;
    "privacy.firstparty.isolate" = true;

    # HTTPS-Only Mode
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_ever_enabled" = true;

    # DNS over HTTPS (optional - 2 = fallback, 3 = strict)
    "network.trr.mode" = 4;

    # WebGL
    "webgl.disabled" = true;

    # Disable Pocket
    "extensions.pocket.enabled" = false;

    # Disable Firefox accounts
    "identity.fxaccounts.enabled" = false;

    # Disable recommendations
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

    # Disable auto-updates
    "app.update.auto" = false;
    "extensions.autoDisableScopes" = 0;
  };

  extensions = [
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    (extension "canvasblocker" "CanvasBlocker@kkapsner.de")
    (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me")
    (extension "darkreader" "addon@darkreader.org")
    # (extension "enhanced-h264ify" "{9a41dee2-b924-4161-a971-7fb35c053a4a}")
  ];
in {
  options.my.features.desktop.apps.zen-browser.enable = lib.mkEnableOption "Zen Browser";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (
        pkgs.wrapFirefox
        inputs.zen-browser.packages.${system}.zen-browser-unwrapped
        {
          extraPrefs = lib.concatLines (
            lib.mapAttrsToList (
              name: value: ''lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});''
            )
            prefs
          );

          extraPolicies = {
            DisableTelemetry = true;
            DisablePocket = true;
            DisableFirefoxStudies = true;

            ExtensionSettings = builtins.listToAttrs extensions;

            EnableTrackingProtection = {
              Value = true;
              Cryptomining = true;
              Fingerprinting = true;
            };

            SearchEngines = {
              Default = "DuckDuckGo";
              Add = [
                {
                  Name = "DuckDuckGo";
                  URLTemplate = "https://duckduckgo.com/?q={searchTerms}";
                  IconURL = "https://duckduckgo.com/favicon.ico";
                  Alias = "@ddg";
                }
              ];
            };
          };
        }
      )
    ];
  };
}
