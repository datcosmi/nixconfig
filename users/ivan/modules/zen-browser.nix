{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.desktop.apps.browsers.zen-browser;

  # Space UUIDs. They must stay stable once used.
  spaceIds = {
    personal = "5e240699-05e9-4e00-b3e5-e336b823542c";
    dev = "8708a37b-4443-4b42-9e12-9218a7ec38ba";
    professional = "74802ede-3671-40e8-82c4-bba7c7dcc3c0";
    shopping = "db741a10-4f76-451c-90aa-72b941441a7f";
  };
in {
  config = lib.mkIf cfg.enable {
    my.features.desktop.apps.browsers.zen-browser = {
      profile = "suavicrema";

      extensions = {
        "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
          id = "proton-pass";
          pinned = true;
        };
      };
    };

    programs.zen-browser = {
      policies = {
        OfferToSaveLogins = false;
      };

      profiles.suavicrema = {
        search = {
          force = true;
          default = lib.mkDefault "ddg";
        };

        settings = {
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "zen.workspaces.continue-where-left-off" = false;
        };

        containersForce = false;
        containers = {
          Personal = {
            id = 1;
            color = "pink";
            icon = "fingerprint";
          };
          Dev = {
            id = 2;
            color = "turquoise";
            icon = "circle";
          };
          Professional = {
            id = 3;
            color = "blue";
            icon = "briefcase";
          };
          Shopping = {
            id = 4;
            color = "yellow";
            icon = "cart";
          };
        };

        spacesForce = false;
        spaces = {
          "Personal" = {
            id = spaceIds.personal;
            position = 1000;
            icon = "💫";
            container = 1;
            pins = {
              "Youtube" = {
                id = "56c3073a-9c94-49c8-83cc-3e1f4c938a3a";
                url = "https://youtube.com";
                position = 101;
                isEssential = true;
              };
              "Whatsapp" = {
                id = "28e81889-e3e4-49a0-b9c7-ccd3ad28307c";
                url = "https://web.whatsapp.com";
                position = 102;
                isEssential = true;
              };
            };
          };
          "Dev" = {
            id = spaceIds.dev;
            position = 2000;
            icon = "💻";
            container = 2;
          };
          "Professional" = {
            id = spaceIds.professional;
            position = 3000;
            icon = "💼";
            container = 3;
          };
          "Shopping" = {
            id = spaceIds.shopping;
            position = 4000;
            icon = "💼";
            container = 4;
          };
        };

        pinsForce = false;
        pinsForceAction = "demote";
      };
    };
  };
}
