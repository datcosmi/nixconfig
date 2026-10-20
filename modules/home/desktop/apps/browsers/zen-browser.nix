{
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop.apps.browsers.zen-browser;

  mkPluginUrl = id: "https://addons.mozilla.org/en-US/firefox/downloads/latest/${id}/latest.xpi";

  mkExtensionEntry = {
    id,
    pinned ? false,
  }: let
    base = {
      install_url = mkPluginUrl id;
      installation_mode = "force_installed";
    };
  in
    if pinned
    then base // {default_area = "navbar";}
    else base;

  # Lets an entry be either a full mkExtensionEntry attrset or just the slug
  mkExtensionSettings = builtins.mapAttrs (_: entry:
    if builtins.isAttrs entry
    then entry
    else mkExtensionEntry {id = entry;});

  baseSettings = {
    # Fingerprinting
    "privacy.resistFingerprinting" = true;
    "privacy.resistFingerprinting.letterboxing" = false;
    "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = true;
    "privacy.trackingprotection.fingerprinting.enabled" = true;
    "privacy.trackingprotection.cryptomining.enabled" = true;
    "webgl.disable-fail-if-major-performance-caveat" = true;

    # Tracking protection / cookies
    "browser.contentblocking.category" = "strict";
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "privacy.query_stripping.enabled" = true;
    "privacy.query_stripping.enabled.pbmode" = true;
    "privacy.donottrackheader.enabled" = true;
    "privacy.globalprivacycontrol.enabled" = true;
    "network.cookie.cookieBehavior" = 5; # 5 = Total Cookie Protection (state partitioning)
    "network.http.referer.XOriginTrimmingPolicy" = 2;

    # Don't wipe state on exit
    "privacy.sanitize.sanitizeOnShutdown" = false;
    "privacy.clearOnShutdown.cookies" = false;
    "privacy.clearOnShutdown.history" = false;
    "privacy.clearOnShutdown.sessions" = false;
    "privacy.clearOnShutdown.cache" = false;
    "privacy.clearOnShutdown.offlineApps" = false;
    "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
    "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
    "privacy.clearOnShutdown_v2.cache" = false;
    "network.cookie.lifetimePolicy" = 0;
    "browser.sessionstore.resume_from_crash" = true;

    # Telemetry / studies / crash reports
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.usage.uploadEnabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "browser.ping-centre.telemetry" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";
    "dom.private-attribution.submission.enabled" = false;
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

    # New tab / sponsored / recommendation junk
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.system.showSponsored" = false;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
    "browser.urlbar.quicksuggest.enabled" = false;
    "browser.discovery.enabled" = false;
    "extensions.pocket.enabled" = false;
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "browser.uitour.enabled" = false;
    "browser.shell.checkDefaultBrowser" = false;

    # Network: no speculative connections / prefetch
    "network.dns.disablePrefetch" = true;
    "network.prefetch-next" = false;
    "network.predictor.enabled" = false;
    "network.http.speculative-parallel-limit" = 0;
    "browser.urlbar.speculativeConnect.enabled" = false;
    "browser.send_pings" = false;
    "network.captive-portal-service.enabled" = false;
    "network.connectivity-service.enabled" = false;

    # Transport security
    "dom.security.https_only_mode" = true;
    "security.ssl.require_safe_negotiation" = true;
    "security.tls.enable_0rtt_data" = false;
    "network.IDN_show_punycode" = true;

    # WebRTC: keep it working, stop local-IP leaks
    "media.peerconnection.ice.default_address_only" = true;

    # Search / forms / passwords
    "browser.search.suggest.enabled" = false;
    "browser.urlbar.suggest.searches" = false;
    "browser.formfill.enable" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "extensions.formautofill.addresses.enabled" = false;
    "signon.rememberSignons" = false;
    "signon.autofillForms" = false;

    # Safe Browsing: keep local protection, drop remote lookups
    "browser.safebrowsing.downloads.remote.enabled" = false;

    # Zen specifics
    "zen.welcome-screen.seen" = true;
  };

  extensions = {
    "uBlock0@raymondhill.net" = mkExtensionEntry {
      id = "ublock-origin";
      pinned = true;
    };
    "78272b6fa58f4a1abaac99321d503a20@proton.me" = mkExtensionEntry {
      id = "proton-pass";
      pinned = true;
    };
    "addon@darkreader.org" = "darkreader";
    # "CanvasBlocker@kkapsner.de" = "canvasblocker";
  };
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
        DisableFeedbackCommands = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;

        HttpsOnlyMode = "force_enabled";

        DNSOverHTTPS = {
          Enabled = true;
          ProviderURL = "https://dns.quad9.net/dns-query";
          Fallback = true;
        };

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
          UrlbarInterventions = false;
        };

        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };

        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
        };

        ExtensionSettings = mkExtensionSettings extensions;
      };

      profiles.suavicrema = {
        id = 0;
        isDefault = true;

        search = {
          force = true;
          default = "ddg";
        };

        settings = lib.mapAttrs (_: lib.mkDefault) baseSettings;
      };
    };
  };
}
