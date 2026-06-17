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

  config = lib.mkIf cfg.enable {
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
        set -g @resurrect-capture-pane-contents 'on'
        set -g @resurrect-processes '"~nvim->nvim" lazygit'
        resurrect_dir="$HOME/.tmux/resurrect"
        set -g @resurrect-dir $resurrect_dir
        set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | sponge $target'
      '';
    };

    catppuccin.tmux = lib.mkIf (theme.palette == "catppuccin-mocha") {
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
        set -g pane-border-style "fg=#313244"
        set -g pane-active-border-style "fg=#cba6f7"
      '';
    };
  };
}
