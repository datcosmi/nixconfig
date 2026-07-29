{
  # ── Environment ────────────────────────────────────────────────────────
  environment = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
    SDL_VIDEODRIVER = "wayland";
    XCURSOR_SIZE = "24";
    GDK_SCALE = "1";
    GUM_CONFIRM_PROMPT_FOREGROUND = "6";
    GUM_CONFIRM_SELECTED_FOREGROUND = "0";
    GUM_CONFIRM_SELECTED_BACKGROUND = "2";
    GUM_CONFIRM_UNSELECTED_FOREGROUND = "0";
    GUM_CONFIRM_UNSELECTED_BACKGROUND = "8";
    XCOMPOSEFILE = "~/.XCompose";
  };

  # ── Input (cursor) ───────────────────────────────────────────────────────
  cursor.hide-when-typing = {};

  # ── Layout ───────────────────────────────────────────────────────────────
  layout = {
    gaps = 6;
    center-focused-column = "never";
    always-center-single-column = {};
    background-color = "#11111b";
    preset-column-widths._children = [
      {proportion = 0.5;}
      {proportion = 0.7;}
      {proportion = 0.8;}
      {proportion = 1.0;}
    ];
    preset-window-heights._children = [
      {proportion = 0.5;}
      {proportion = 0.7;}
      {proportion = 0.8;}
      {proportion = 1.0;}
    ];
    default-column-width.proportion = 0.6;
    focus-ring = {
      off = {};
      width = 2;
      active-gradient._props = {
        from = "#ffbae5";
        to = "#cabaff";
        angle = 45;
      };
      inactive-color = "#595959aa";
    };
    border = {
      on = {};
      width = 2;
      active-gradient._props = {
        from = "#f5c2e7CC";
        to = "#b4befeCC";
        angle = 0;
      };
      inactive-color = "#59595955";
    };
    shadow = {
      on = {};
      softness = 25;
      spread = 3;
      offset._props = {
        x = 0;
        y = 5;
      };
      color = "#1a1b2699";
    };
    struts = {
      left = 7;
      right = 7;
      top = 7;
      bottom = 7;
    };
  };

  prefer-no-csd = {};

  screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

  # ── Animations ─────────────────────────────────────────────────────────
  animations = {
    window-open = {
      duration-ms = 250;
      curve = "ease-out-expo";
      custom-shader = ''
        vec4 open_color(vec3 coords_geo, vec3 size_geo) {
            float progress = niri_clamped_progress;
            vec2 coords = (coords_geo.xy - vec2(0.5)) / max(progress, 1e-5) + vec2(0.5);
            vec4 color = texture2D(niri_tex, coords);
            return color * progress;
        }
      '';
    };
    window-close = {
      duration-ms = 180;
      curve = "ease-out-quad";
    };
    workspace-switch.spring._props = {
      damping-ratio = 1.0;
      stiffness = 1000;
      epsilon = 0.0001;
    };
    window-movement.spring._props = {
      damping-ratio = 1.0;
      stiffness = 800;
      epsilon = 0.0001;
    };
    window-resize.spring._props = {
      damping-ratio = 1.0;
      stiffness = 800;
      epsilon = 0.0001;
    };
    horizontal-view-movement.spring._props = {
      damping-ratio = 1.0;
      stiffness = 800;
      epsilon = 0.0001;
    };
  };

  blur = {
    passes = 4;
    offset = 6;
    noise = 0.02;
    saturation = 1.5;
  };

  hotkey-overlay.skip-at-startup = {};

  # ── Repeated top-level nodes ──────────────────────────────────────────
  # layer-rule, spawn(-sh)-at-startup, window-rule all live here, in the
  # same relative order as the original config.kdl (window-rule order can
  # matter for precedence, so this is preserved rather than alphabetized).
  _children = [
    # noctalia overview layer
    {
      layer-rule = {
        match._props.namespace = "^noctalia-overview*";
        place-within-backdrop = true;
      };
    }
    # rofi popup
    {
      layer-rule = {
        match._props.namespace = "^rofi*";
        geometry-corner-radius = 24;
        background-effect = {
          blur = true;
          xray = false;
        };
      };
    }

    {spawn-at-startup = "noctalia-shell";}
    {spawn-at-startup = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";}
    # Clipboard manager — text and images
    {spawn-sh-at-startup = "wl-paste --type text --watch cliphist store";}
    {spawn-sh-at-startup = "wl-paste --type image --watch cliphist store";}
    {spawn-sh-at-startup = "steam -silent";}

    # Global: rounded corners + blur on everything
    {
      window-rule = {
        geometry-corner-radius = 11;
        clip-to-geometry = true;
        background-effect = {
          blur = true;
          xray = false;
        };
      };
    }
    {
      window-rule = {
        match._props.app-id = "^org\\.wezfurlong\\.wezterm$";
        default-column-width = {};
      };
    }
    # Firefox / Zen picture-in-picture — floating
    {
      window-rule = {
        match._props = {
          app-id = "(firefox|zen)$";
          title = "^Picture-in-Picture$";
        };
        open-floating = true;
      };
    }
    # Floating utility windows (btop, nvtop, wiremix, bluetui, impala)
    {
      window-rule = {
        match._props.app-id = "^(btop|nvtop|wiremix|bluetui|impala)$";
        open-floating = true;
        draw-border-with-background = false;
        default-column-width.fixed = 1280;
        default-window-height.fixed = 800;
      };
    }
    # Kitty
    {
      window-rule = {
        match._props.app-id = "kitty";
        draw-border-with-background = false;
      };
    }
    # Yazi file manager
    {
      window-rule = {
        match._props.app-id = "yazi";
        default-column-width.fixed = 1280;
        draw-border-with-background = false;
      };
    }
    # GNOME apps, virt-manager
    {
      window-rule = {
        match._props.app-id = "^(org\\.gnome\\.Loupe|org\\.gnome\\.NautilusPreviewer|virt-manager|gnome-disks)$";
        open-floating = true;
        default-column-width.fixed = 1280;
        default-window-height.fixed = 800;
      };
    }
    # Proton Pass, system-config-printer
    {
      window-rule = {
        match._props.app-id = "^(system-config-printer|Proton Pass)$";
        open-floating = true;
        default-column-width.fixed = 1280;
        default-window-height.fixed = 800;
      };
    }
    {
      window-rule = {
        match._props = {
          app-id = "steam";
          title = "Steam";
        };
        default-column-width.fixed = 1380;
      };
    }
    {
      window-rule = {
        match._props = {
          app-id = "steam";
          title = "Friends List";
        };
        default-column-width.fixed = 460;
      };
    }

    # Disabled in the original via `/-window-rule` (KDL slashdash comment).
    # Uncomment to block KeePassXC / GNOME Secrets from screen capture:
    # {
    #   window-rule = {
    #     match._children = [
    #       {_props.app-id = "^org\\.keepassxc\\.KeePassXC$";}
    #       {_props.app-id = "^org\\.gnome\\.World\\.Secrets$";}
    #     ];
    #     block-out-from = "screen-capture";
    #   };
    # }
  ];

  # ── Keybindings ──────────────────────────────────────────────────────────
  binds = {
    "Mod+Shift+Slash".show-hotkey-overlay = {};

    # ── Terminal & Launchers ────────────────────────────────────────────
    "Mod+Return" = {
      _props.hotkey-overlay-title = "Open Terminal";
      spawn = "kitty";
    };
    "Mod+Shift+Return" = {
      _props.hotkey-overlay-title = "Open Terminal with tmux";
      spawn-sh = "kitty -e tmux";
    };
    "Mod+Space" = {
      _props.hotkey-overlay-title = "App Launcher";
      spawn-sh = "noctalia-shell ipc call launcher toggle";
    };
    "Mod+Ctrl+E" = {
      _props.hotkey-overlay-title = "Emoji Picker";
      spawn-sh = "noctalia-shell ipc call launcher emoji";
    };
    "Mod+Alt+C" = {
      _props.hotkey-overlay-title = "Calculator: rofi-calc";
      spawn-sh = "rofi -show calc -modi calc -no-show-match -no-sort";
    };
    "Mod+V" = {
      _props.hotkey-overlay-title = "Clipboard History";
      spawn-sh = "noctalia-shell ipc call launcher clipboard";
    };

    # ── Applications ──────────────────────────────────────────────────────
    "Mod+Shift+B" = {
      _props.hotkey-overlay-title = "Open Browser";
      spawn = "zen";
    };
    "Mod+Shift+X" = {
      _props.hotkey-overlay-title = "File Manager";
      spawn = "nautilus";
    };
    "Mod+Shift+Y" = {
      _props.hotkey-overlay-title = "File Manager";
      spawn-sh = "kitty --class yazi -e yazi";
    };
    "Mod+Shift+D" = {
      _props.hotkey-overlay-title = "Open Discord";
      spawn = "discord";
    };
    "Mod+Shift+G" = {
      _props.hotkey-overlay-title = "Open Steam";
      spawn = "steam";
    };
    "Mod+Shift+M" = {
      _props.hotkey-overlay-title = "Open Spotify";
      spawn = "spotify";
    };
    "Mod+Shift+A" = {
      _props.hotkey-overlay-title = "Authenticator";
      spawn = "enteauth";
    };
    "Mod+Shift+P" = {
      _props.hotkey-overlay-title = "Password Manager";
      spawn = "proton-pass";
    };
    "Mod+Ctrl+V" = {
      _props.hotkey-overlay-title = "ProtonVPN Rofi Tool";
      spawn-sh = "protonvpn-rofi";
    };

    # ── TUI Utilities in Kitty ────────────────────────────────────────────
    "Mod+Shift+T" = {
      _props.hotkey-overlay-title = "System Monitor";
      spawn-sh = "kitty --class btop -e btop";
    };
    "Mod+Shift+N" = {
      _props.hotkey-overlay-title = "Nvidia GPU Monitor";
      spawn-sh = "kitty --class nvtop -e nvtop";
    };
    "Mod+Shift+S" = {
      _props.hotkey-overlay-title = "Audio Mixer";
      spawn-sh = "kitty --class wiremix -e wiremix";
    };
    "Mod+Shift+E" = {
      _props.hotkey-overlay-title = "Bluetooth TUI";
      spawn-sh = "kitty --class bluetui -e bluetui";
    };
    "Mod+Shift+W" = {
      _props.hotkey-overlay-title = "Wifi TUI";
      spawn-sh = "kitty --class impala -e impala";
    };

    # ── System Controls ──────────────────────────────────────────────────
    "Mod+Alt+Equal" = {
      _props.hotkey-overlay-title = "DDC Raise Brightness";
      spawn-sh = "noctalia-shell ipc call brightness increase";
    };
    "Mod+Alt+Minus" = {
      _props.hotkey-overlay-title = "DDC Lower Brightness";
      spawn-sh = "noctalia-shell ipc call brightness decrease";
    };
    "Mod+Alt+L".switch-layout = "next";
    "Mod+Ctrl+N" = {
      _props.hotkey-overlay-title = "Notification Center";
      spawn-sh = "noctalia-shell ipc call notifications toggleHistory";
    };
    "Mod+Shift+Space" = {
      _props.hotkey-overlay-title = "Restart Waybar";
      spawn-sh = "pkill waybar || waybar";
    };
    "Mod+Q" = {
      _props.hotkey-overlay-title = "Toggle Audio Output (Sinks)";
      spawn-sh = "toggle-audio-output Sinks";
    };
    "Mod+Shift+Q" = {
      _props.hotkey-overlay-title = "Toggle Audio Input (Sources)";
      spawn-sh = "toggle-audio-output Sources";
    };
    "Mod+Ctrl+Space" = {
      _props.hotkey-overlay-title = "Toggle ProtonVPN";
      spawn-sh = "pkill -USR1 protonvpn || protonvpn-app";
    };
    # Screen reader (orca) — works on lock screen
    "Super+Alt+S" = {
      _props = {
        allow-when-locked = true;
        hotkey-overlay-title = null;
      };
      spawn-sh = "pkill orca || exec orca";
    };

    # ── Session / Lock / Power ────────────────────────────────────────────
    "Mod+Escape" = {
      _props = {
        allow-inhibiting = false;
        hotkey-overlay-title = "Logout Menu";
      };
      spawn-sh = "noctalia-shell ipc call sessionMenu toggle";
    };
    "Mod+Shift+Escape" = {
      _props = {
        allow-inhibiting = false;
        hotkey-overlay-title = "Toggle Keyboard Inhibitor";
      };
      toggle-keyboard-shortcuts-inhibit = {};
    };
    "Mod+Shift+Ctrl+E".quit = {};
    "Ctrl+Alt+Delete".quit = {};
    "Mod+Ctrl+P" = {
      _props.hotkey-overlay-title = "Power Off Monitors";
      power-off-monitors = {};
    };

    # ── Window Management ─────────────────────────────────────────────────
    "Mod+W" = {
      _props = {
        repeat = false;
        hotkey-overlay-title = "Close Window";
      };
      close-window = {};
    };
    "Mod+F" = {
      _props.hotkey-overlay-title = "Maximize Column";
      maximize-column = {};
    };
    "Mod+Shift+F" = {
      _props.hotkey-overlay-title = "Fullscreen Window";
      fullscreen-window = {};
    };
    "Mod+Ctrl+F" = {
      _props.hotkey-overlay-title = "Expand Column to Available Width";
      expand-column-to-available-width = {};
    };
    "Mod+M" = {
      _props.hotkey-overlay-title = "Maximize Window to Edges";
      maximize-window-to-edges = {};
    };
    "Mod+T" = {
      _props = {
        repeat = false;
        hotkey-overlay-title = "Toggle Floating";
      };
      toggle-window-floating = {};
    };
    "Mod+Shift+V" = {
      _props = {
        repeat = false;
        hotkey-overlay-title = "Switch Floating↔Tiling Focus";
      };
      switch-focus-between-floating-and-tiling = {};
    };
    "Mod+C" = {
      _props.hotkey-overlay-title = "Center Column";
      center-column = {};
    };
    "Mod+Ctrl+C" = {
      _props.hotkey-overlay-title = "Center All Visible Columns";
      center-visible-columns = {};
    };
    "Mod+O" = {
      _props = {
        repeat = false;
        hotkey-overlay-title = "Toggle Overview";
      };
      toggle-overview = {};
    };
    "Mod+G" = {
      _props = {
        repeat = false;
        hotkey-overlay-title = "Toggle Tabbed Column";
      };
      toggle-column-tabbed-display = {};
    };

    # ── Column Widths & Window Heights ───────────────────────────────────
    "Mod+R" = {
      _props.hotkey-overlay-title = "Cycle Column Width Preset";
      switch-preset-column-width = {};
    };
    "Mod+Shift+R" = {
      _props.hotkey-overlay-title = "Cycle Window Height Preset";
      switch-preset-window-height = {};
    };
    "Mod+Ctrl+R" = {
      _props.hotkey-overlay-title = "Reset Window Height";
      reset-window-height = {};
    };
    "Mod+Minus".set-column-width = "-10%";
    "Mod+Equal".set-column-width = "+10%";
    "Mod+Shift+Minus".set-window-height = "-10%";
    "Mod+Shift+Equal".set-window-height = "+10%";

    # ── Column Stacking ───────────────────────────────────────────────────
    "Mod+Comma" = {
      _props.hotkey-overlay-title = "Pull Window into Column";
      consume-window-into-column = {};
    };
    "Mod+Period" = {
      _props.hotkey-overlay-title = "Expel Window from Column";
      expel-window-from-column = {};
    };
    "Mod+BracketLeft".consume-or-expel-window-left = {};
    "Mod+BracketRight".consume-or-expel-window-right = {};

    # ── Focus Navigation ──────────────────────────────────────────────────
    "Mod+H".focus-column-left = {};
    "Mod+L".focus-column-right = {};
    "Mod+J".focus-window-down = {};
    "Mod+K".focus-window-up = {};
    "Mod+Left".focus-column-left = {};
    "Mod+Right".focus-column-right = {};
    "Mod+Down".focus-window-down = {};
    "Mod+Up".focus-window-up = {};
    "Mod+Home".focus-column-first = {};
    "Mod+End".focus-column-last = {};

    # ── Move Windows & Columns ────────────────────────────────────────────
    "Mod+Ctrl+H".move-column-left = {};
    "Mod+Ctrl+L".move-column-right = {};
    "Mod+Ctrl+J".move-window-down = {};
    "Mod+Ctrl+K".move-window-up = {};
    "Mod+Ctrl+Left".move-column-left = {};
    "Mod+Ctrl+Right".move-column-right = {};
    "Mod+Ctrl+Down".move-window-down = {};
    "Mod+Ctrl+Up".move-window-up = {};
    "Mod+Ctrl+Home".move-column-to-first = {};
    "Mod+Ctrl+End".move-column-to-last = {};

    # ── Monitor Focus & Move ──────────────────────────────────────────────
    "Mod+Shift+H".focus-monitor-left = {};
    "Mod+Shift+L".focus-monitor-right = {};
    "Mod+Shift+J".focus-monitor-down = {};
    "Mod+Shift+K".focus-monitor-up = {};
    "Mod+Shift+Left".focus-monitor-left = {};
    "Mod+Shift+Right".focus-monitor-right = {};
    "Mod+Shift+Down".focus-monitor-down = {};
    "Mod+Shift+Up".focus-monitor-up = {};

    "Mod+Ctrl+Shift+H".move-column-to-monitor-left = {};
    "Mod+Ctrl+Shift+L".move-column-to-monitor-right = {};
    "Mod+Ctrl+Shift+J".move-column-to-monitor-down = {};
    "Mod+Ctrl+Shift+K".move-column-to-monitor-up = {};
    "Mod+Ctrl+Shift+Left".move-column-to-monitor-left = {};
    "Mod+Ctrl+Shift+Right".move-column-to-monitor-right = {};
    "Mod+Ctrl+Shift+Down".move-column-to-monitor-down = {};
    "Mod+Ctrl+Shift+Up".move-column-to-monitor-up = {};

    # ── Workspace Navigation ──────────────────────────────────────────────
    "Mod+Tab" = {
      _props.cooldown-ms = 100;
      focus-workspace-down = {};
    };
    "Mod+Shift+Tab" = {
      _props.cooldown-ms = 100;
      focus-workspace-up = {};
    };
    "Mod+U".focus-workspace-down = {};
    "Mod+I".focus-workspace-up = {};
    "Mod+Page_Down".focus-workspace-down = {};
    "Mod+Page_Up".focus-workspace-up = {};

    "Mod+Ctrl+U".move-column-to-workspace-down = {};
    "Mod+Ctrl+I".move-column-to-workspace-up = {};
    "Mod+Ctrl+Page_Down".move-column-to-workspace-down = {};
    "Mod+Ctrl+Page_Up".move-column-to-workspace-up = {};

    "Mod+Shift+U".move-workspace-down = {};
    "Mod+Shift+I".move-workspace-up = {};

    # Numbered workspace access
    "Mod+1".focus-workspace = 1;
    "Mod+2".focus-workspace = 2;
    "Mod+3".focus-workspace = 3;
    "Mod+4".focus-workspace = 4;
    "Mod+5".focus-workspace = 5;
    "Mod+6".focus-workspace = 6;
    "Mod+7".focus-workspace = 7;
    "Mod+8".focus-workspace = 8;
    "Mod+9".focus-workspace = 9;

    # Move column to numbered workspace
    "Mod+Shift+1".move-column-to-workspace = 1;
    "Mod+Shift+2".move-column-to-workspace = 2;
    "Mod+Shift+3".move-column-to-workspace = 3;
    "Mod+Shift+4".move-column-to-workspace = 4;
    "Mod+Shift+5".move-column-to-workspace = 5;
    "Mod+Shift+6".move-column-to-workspace = 6;
    "Mod+Shift+7".move-column-to-workspace = 7;
    "Mod+Shift+8".move-column-to-workspace = 8;
    "Mod+Shift+9".move-column-to-workspace = 9;

    # ── Mouse Scroll Workspace Navigation ─────────────────────────────────
    "Mod+WheelScrollDown" = {
      _props.cooldown-ms = 150;
      focus-workspace-down = {};
    };
    "Mod+WheelScrollUp" = {
      _props.cooldown-ms = 150;
      focus-workspace-up = {};
    };
    "Mod+Ctrl+WheelScrollDown" = {
      _props.cooldown-ms = 150;
      move-column-to-workspace-down = {};
    };
    "Mod+Ctrl+WheelScrollUp" = {
      _props.cooldown-ms = 150;
      move-column-to-workspace-up = {};
    };

    "Mod+WheelScrollRight".focus-column-right = {};
    "Mod+WheelScrollLeft".focus-column-left = {};
    "Mod+Ctrl+WheelScrollRight".move-column-right = {};
    "Mod+Ctrl+WheelScrollLeft".move-column-left = {};

    "Mod+Shift+WheelScrollDown".focus-column-right = {};
    "Mod+Shift+WheelScrollUp".focus-column-left = {};
    "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = {};
    "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = {};

    # ── Screenshots ────────────────────────────────────────────────────────
    "Print".screenshot = {};
    "Ctrl+Print".screenshot-screen = {};
    "Alt+Print".screenshot-window = {};

    "Mod+Alt+B".spawn-sh = "playerctl --player=ShairportSync,spotify,mpv,%any play-pause";
    "Mod+Alt+N".spawn-sh = "playerctl --player=ShairportSync,spotify,mpv,%any previous";
    "Mod+Alt+M".spawn-sh = "playerctl --player=ShairportSync,spotify,mpv,%any next";

    # ── Volume (PipeWire / WirePlumber) ───────────────────────────────────
    "XF86AudioRaiseVolume" = {
      _props.allow-when-locked = true;
      spawn-sh = "noctalia-shell ipc call volume increase";
    };
    "XF86AudioLowerVolume" = {
      _props.allow-when-locked = true;
      spawn-sh = "noctalia-shell ipc call volume decrease";
    };
    "XF86AudioMute" = {
      _props.allow-when-locked = true;
      spawn-sh = "noctalia-shell ipc call volume muteOutput";
    };
    "XF86AudioMicMute" = {
      _props.allow-when-locked = true;
      spawn-sh = "noctalia-shell ipc call volume muteInput";
    };

    # ── Media Keys (playerctl / MPRIS) ────────────────────────────────────
    "XF86AudioPlay" = {
      _props.allow-when-locked = true;
      spawn-sh = "playerctl --player=ShairportSync,spotify,mpv,%any play-pause";
    };
    "XF86AudioPause" = {
      _props.allow-when-locked = true;
      spawn-sh = "playerctl --player=ShairportSync,spotify,mpv,%any play-pause";
    };
    "XF86AudioStop" = {
      _props.allow-when-locked = true;
      spawn-sh = "playerctl --player=ShairportSync,spotify,mpv,%any stop";
    };
    "XF86AudioPrev" = {
      _props.allow-when-locked = true;
      spawn-sh = "playerctl --player=ShairportSync,spotify,mpv,%any previous";
    };
    "XF86AudioNext" = {
      _props.allow-when-locked = true;
      spawn-sh = "playerctl --player=ShairportSync,spotify,mpv,%any next";
    };

    # ── Brightness ─────────────────────────────────────────────────────────
    "XF86MonBrightnessUp" = {
      _props.allow-when-locked = true;
      spawn-sh = "noctalia-shell ipc call brightness increase";
    };
    "XF86MonBrightnessDown" = {
      _props.allow-when-locked = true;
      spawn-sh = "noctalia-shell ipc call brightness decrease";
    };
  };
}
