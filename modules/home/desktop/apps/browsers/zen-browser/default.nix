{
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop.apps.browsers.zen-browser;
  theme = config.my.features.theme;

  # Loading the custom Catppuccin userChrome.css seems to break the toolbar's hover area, but apparently
  # it can be fixed by absurdly elevating the hover duration value ??? so what the hell sure
  hasCatppuccin = theme.palette == "catppuccin";

  toolbarHoverDuration =
    if hasCatppuccin
    then 600000
    else 1000;

  mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

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

  # An entry in extensions is either just the slug or { id, pinned }
  mkExtensionSettings = builtins.mapAttrs (_: entry:
    if builtins.isString entry
    then mkExtensionEntry {id = entry;}
    else mkExtensionEntry {inherit (entry) id pinned;});

  baseSettings = {
    # Cookies and session store
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

    # Zen specifics
    "zen.welcome-screen.seen" = true;
    "zen.urlbar.behavior" = "float";
    "zen.view.compact.toolbar-hide-after-hover.duration" = toolbarHoverDuration;

    # Firefox needs this enabled to load custom CSS
    "toolkit.legacyUserProfileCustomizations.stylesheets" = hasCatppuccin;
  };
in {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options.my.features.desktop.apps.browsers.zen-browser = {
    enable = lib.mkEnableOption "Enable Zen Browser";

    profile = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Name of the Zen profile that the modules write into";
    };

    extensions = lib.mkOption {
      type = with lib.types;
        attrsOf (either str (submodule {
          options = {
            id = lib.mkOption {
              type = str;
              description = "Add-on slug on addons.mozilla.org.";
            };
            pinned = lib.mkOption {
              type = bool;
              default = false;
              description = "Pin the extension button to the navbar.";
            };
          };
        }));
      default = {};
      example = {
        "addon@darkreader.org" = "darkreader";
        "uBlock0@raymondhill.net" = {
          id = "ublock-origin";
          pinned = true;
        };
      };
      description = "Extensions to force-install";
    };
  };

  config = lib.mkIf cfg.enable {
    # Always on
    my.features.desktop.apps.browsers.zen-browser.extensions = {
      "uBlock0@raymondhill.net" = {
        id = "ublock-origin";
        pinned = true;
      };
      "addon@darkreader.org" = "darkreader";
    };

    programs.zen-browser = {
      enable = true;

      policies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        DisablePocket = true;
        DisableFirefoxStudies = true;
        DisableFeedbackCommands = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        PasswordManagerEnabled = false;

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
          UrlbarInterventions = false;
        };

        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
        };

        ExtensionSettings = mkExtensionSettings cfg.extensions;
      };

      profiles.${cfg.profile} = {
        id = 0;
        isDefault = true;

        settings = lib.mapAttrs (_: lib.mkDefault) baseSettings;
      };
    };

    home.file.".config/zen/suavicrema/chrome" = lib.mkIf hasCatppuccin {
      source = ./chrome/catppuccin/${theme.catppuccin.flavor};
      recursive = true;
    };
  };
}
