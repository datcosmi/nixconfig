{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.terminal.kitty;
in {
  options.my.features.terminal.kitty.enable = lib.mkEnableOption "Enable kitty terminal";

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      settings = {
        # Font
        font_family = "JetBrainsMono Nerd Font";
        bold_italic_font = "auto";
        font_size = 11.0;

        # Window
        window_padding_width = 17;
        hide_window_decorations = "yes";
        show_window_resize_notification = "no";
        confirm_os_window_close = 0;

        # Clipboard keybindings
        "map ctrl+insert" = "copy_to_clipboard";
        "map shift+insert" = "paste_from_clipboard";

        # Remote control
        single_instance = "yes";
        allow_remote_control = "yes";

        # Aesthetics
        cursor_shape = "block";
        cursor_trail = 3;
        enable_audio_bell = "no";
        background_opacity = 0.95;

        # Tab bar styling
        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      };
    };
  };
}
