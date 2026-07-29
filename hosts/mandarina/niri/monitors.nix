{
  _children = [
    {
      output = {
        _args = ["eDP-1"];
        mode = "1920x1080@60.000";
        scale = 1.2;
        position._props = {
          x = 1920;
          y = 0;
        };
        focus-at-startup = {};
        backdrop-color = "#11111b";
      };
    }

    {
      workspace = {
        _args = ["1"];
        open-on-output = "eDP-1";
      };
    }
    {
      workspace = {
        _args = ["2"];
        open-on-output = "eDP-1";
      };
    } # Discord, Spotify
    {
      workspace = {
        _args = ["3"];
        open-on-output = "eDP-1";
      };
    } # Browsers

    {
      window-rule = {
        match._props.app-id = "(firefox|zen|librewolf)$";
        opacity = 1.0;
        open-maximized = true;
        open-maximized-to-edges = false;
        open-on-workspace = "1";
      };
    }
    # Zen "Library" popup — floating
    {
      window-rule = {
        match._props = {
          app-id = "zen";
          title = "Library";
        };
        open-floating = true;
      };
    }
    # Chromium-based browsers
    {
      window-rule = {
        match._props.app-id = "^(google-chrome|chromium|brave-browser|microsoft-edge|vivaldi-stable|helium)$";
        opacity = 1.0;
        open-maximized = true;
        open-maximized-to-edges = false;
        open-on-workspace = "1";
      };
    }
    # Discord and Spotify
    {
      window-rule = {
        match._props.app-id = "(?i)spotify";
        open-on-workspace = "2";
        opacity = 0.96;
        open-maximized = true;
        open-focused = true;
      };
    }
    {
      window-rule = {
        match._props.app-id = "^(discord|com\\.discordapp\\.Discord)$";
        opacity = 1.0;
        open-maximized = true;
        open-focused = true;
        draw-border-with-background = false;
      };
    }
    # Stremio and Obsidian
    {
      window-rule = {
        match._props.app-id = "^(com\\.stremio\\.stremio|obsidian)$";
        open-maximized = true;
      };
    }
    # Steam
    {
      window-rule = {
        match._props.app-id = "steam";
        open-on-workspace = "3";
        open-floating = true;
        opacity = 1.0;
      };
    }
  ];
}
