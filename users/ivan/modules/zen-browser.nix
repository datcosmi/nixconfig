{
  lib,
  config,
  pkgs,
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
        "amptra@keepa.com" = "keepa";
      };
    };

    programs.zen-browser = {
      policies = {
        OfferToSaveLogins = false;
        SearchSuggestEnabled = false;

        Preferences = {
          "browser.urlbar.suggest.searches" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.quicksuggest.enabled" = {
            Value = false;
            Status = "locked";
          };
        };
      };

      profiles.suavicrema = {
        search = {
          force = true;
          default = "ddg";

          engines = {
            mynixos = {
              name = "My NixOS";
              urls = [
                {
                  template = "https://mynixos.com/search?q={searchTerms}";
                  params = [
                    {
                      name = "query";
                      value = "searchTerms";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nx"];
            };
          };
        };

        mods = [
          "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
          "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
          "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
          "cb15abdb-0514-4e09-8ce5-722cf1f4a20f" # Hide Extension Name
          "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
          "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
          "c8d9e6e6-e702-4e15-8972-3596e57cf398" # Zen Back Forward
        ];

        settings = {
          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "zen.workspaces.continue-where-left-off" = false;
          "zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true;
          "zen.tabs.ctrl-tab.ignore-pending-tabs" = true;
        };

        containersForce = true;
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

        spacesForce = true;
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
                container = 1;
              };
              "Whatsapp" = {
                id = "28e81889-e3e4-49a0-b9c7-ccd3ad28307c";
                url = "https://web.whatsapp.com";
                position = 102;
                isEssential = true;
                container = 1;
              };
              "Twitter" = {
                id = "66f40e07-cce4-4b2f-b0d9-fa1378b04c94";
                url = "https://x.com";
                position = 103;
                isEssential = true;
                container = 1;
              };
              "Reddit" = {
                id = "eb20432e-2239-48e1-9946-e68474c35159";
                url = "https://reddit.com";
                position = 104;
                isEssential = true;
                container = 1;
              };
            };
          };
          "Dev" = {
            id = spaceIds.dev;
            position = 2000;
            icon = "💻";
            container = 2;
            pins = {
              "GitHub" = {
                id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
                url = "https://github.com";
                position = 101;
                isEssential = true;
                container = 2;
              };
              "Claude" = {
                id = "918ec525-d5de-4700-a0f7-33aa4cb6ffcc";
                url = "https://claude.ai";
                position = 102;
                isEssential = true;
                container = 2;
              };
              "ChaBiBiPi" = {
                id = "cf646475-e7d8-4147-9da4-39857000470f";
                url = "https://chatgpt.com";
                position = 103;
                isEssential = true;
                container = 2;
              };
              "MyNixOS" = {
                id = "c15bf767-c870-4d8b-a5ad-95d4ace0ed25";
                url = "https://mynixos.com";
                position = 104;
                isEssential = true;
                container = 2;
              };
            };
          };
          "Professional" = {
            id = spaceIds.professional;
            position = 3000;
            icon = "💼";
            container = 3;
            pins = {
              "ProtonDrive" = {
                id = "d2769513-6fea-4346-8b3d-b5c67fa4740a";
                url = "https://drive.proton.me";
                position = 101;
                isEssential = true;
                container = 3;
              };
              "ProtonMail" = {
                id = "3aba17b3-5162-4daa-b430-4a1e394df28b";
                url = "https://mail.proton.me";
                position = 102;
                isEssential = true;
                container = 3;
              };
              "LinkedIn" = {
                id = "3ce84843-a83c-4d89-ab40-4cade20c37b6";
                url = "https://linkedin.com";
                position = 103;
                isEssential = true;
                container = 3;
              };
              "Indeed" = {
                id = "e3081027-ed2d-42cd-ac16-b1dba4b15896";
                url = "https://indeed.com";
                position = 104;
                isEssential = true;
                container = 3;
              };
              "Overleaf" = {
                id = "0e56d3ae-7418-4ed2-b509-d69b91f8f7f3";
                url = "https://overleaf.com";
                position = 105;
                isEssential = true;
                container = 3;
              };
            };
          };
          "Shopping" = {
            id = spaceIds.shopping;
            position = 4000;
            icon = "🛒";
            container = 4;
            pins = {
              "Amazon" = {
                id = "fbe04397-42e6-4767-84e6-9a13bd15958e";
                url = "https://amazon.com.mx";
                position = 101;
                isEssential = true;
                container = 4;
              };
              "MercadoLibre" = {
                id = "df0eb859-3f50-48fc-8f69-46fd377dc184";
                url = "https://mercadolibre.com.mx";
                position = 102;
                isEssential = true;
                container = 4;
              };
            };
          };
        };

        pinsForce = true;
        pinsForceAction = "demote";
      };
    };
  };
}
