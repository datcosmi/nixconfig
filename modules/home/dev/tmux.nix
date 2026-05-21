{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.dev.tmux;
  theme = config.my.features.theme;
in {
  options.my.features.dev.tmux.enable = lib.mkEnableOption "Enable tmux";

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable) {
      programs.tmux = {
        enable = true;
        shortcut = "s";
        mouse = true;
        baseIndex = 1;
        terminal = "tmux-256color";

        plugins = with pkgs.tmuxPlugins; [
          sensible
          yank
          vim-tmux-navigator
          resurrect
          continuum
        ];

        extraConfig = ''
          set -ag terminal-overrides ",xterm-256color:RGB"
          set-window-option -g mode-keys vi
          bind-key h select-pane -L
          bind-key j select-pane -D
          bind-key k select-pane -U
          bind-key l select-pane -R
          bind-key S-Left swap-window -t -1
          bind-key S-Right swap-window -t +1
          bind-key m choose-window -F "#{window_index}: #{window_name}" "join-pane -h -t %%"
          bind-key M choose-window -F "#{window_index}: #{window_name}" "join-pane -v -t %%"
          set -g status-style bg=default
          set-option -g status-position bottom
        '';
      };
    })

    (lib.mkIf (cfg.enable && theme.palette == "catppuccin-mocha") {
      catppuccin.tmux = {
        enable = true;
        flavor = "mocha";
        extraConfig = ''
          set -g @catppuccin_window_status_style "rounded"
          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -g @catppuccin_window_default_text " #W"
          set -g @catppuccin_window_current_text " #W"
          set -g @catppuccin_window_text " #W"
        '';
      };
    })
  ];
}
