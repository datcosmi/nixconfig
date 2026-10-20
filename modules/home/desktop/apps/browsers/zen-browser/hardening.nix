{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop.apps.browsers.zen-browser;
  hcfg = cfg.hardening;

  mkDefaults = lib.mapAttrs (_: lib.mkDefault);

  hardeningSettings = {
    # Tracking protection / cookies
    "privacy.trackingprotection.fingerprinting.enabled" = true;
    "privacy.trackingprotection.cryptomining.enabled" = true;
    "browser.contentblocking.category" = "strict";
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "privacy.query_stripping.enabled" = true;
    "privacy.query_stripping.enabled.pbmode" = true;
    "privacy.donottrackheader.enabled" = true;
    "privacy.globalprivacycontrol.enabled" = true;
    "network.cookie.cookieBehavior" = 5; # 5 = Total Cookie Protection (state partitioning)
    "network.http.referer.XOriginTrimmingPolicy" = 2;

    # Network: no speculative connections / prefetch
    "network.dns.disablePrefetch" = true;
    "network.prefetch-next" = false;
    "network.predictor.enabled" = false;
    "network.http.speculative-parallel-limit" = 0;
    "browser.urlbar.speculativeConnect.enabled" = false;
    "browser.send_pings" = false;
    "network.captive-portal-service.enabled" = false; # breaks captive-portal detection
    "network.connectivity-service.enabled" = false;

    # Transport security
    "dom.security.https_only_mode" = true;
    "security.ssl.require_safe_negotiation" = true;
    "security.tls.enable_0rtt_data" = false;
    "network.IDN_show_punycode" = true;

    # WebRTC: keep it working, stop local-IP leaks
    "media.peerconnection.ice.default_address_only" = true;

    # Search suggestions / form autofill
    "browser.search.suggest.enabled" = false;
    "browser.urlbar.suggest.searches" = false;
    "browser.formfill.enable" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "extensions.formautofill.addresses.enabled" = false;

    # Safe Browsing: keep local protection, drop remote lookups
    "browser.safebrowsing.downloads.remote.enabled" = false;
  };

  # Separate toggle in case it breaks sites
  fingerprintingSettings = {
    "privacy.resistFingerprinting" = true;
    "privacy.resistFingerprinting.letterboxing" = false;
    "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = true;
    "webgl.disable-fail-if-major-performance-caveat" = true;
  };
in {
  options.my.features.desktop.apps.browsers.zen-browser.hardening = {
    enable = lib.mkEnableOption "Enable privacy/security hardening for Zen Browser";

    fingerprinting.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable privacy.resistFingerprinting. Disable it if it breaks sites";
    };
  };

  config = lib.mkIf (cfg.enable && hcfg.enable) {
    my.features.desktop.apps.browsers.zen-browser.extensions = {
      "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
      # "CanvasBlocker@kkapsner.de" = "canvasblocker";
    };

    programs.zen-browser = {
      policies = {
        DisableFirefoxAccounts = lib.mkDefault true;
        HttpsOnlyMode = lib.mkDefault "force_enabled";

        DNSOverHTTPS = lib.mkDefault {
          Enabled = true;
          ProviderURL = "https://dns.quad9.net/dns-query";
          Fallback = true;
        };

        EnableTrackingProtection = lib.mkDefault {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
      };

      profiles.${cfg.profile}.settings = mkDefaults (
        hardeningSettings
        // lib.optionalAttrs hcfg.fingerprinting.enable fingerprintingSettings
      );
    };
  };
}
