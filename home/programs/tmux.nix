{ ... }:
{
  programs.tmux = {
    enable = true;
    # Plugins come from TPM (below), not Nix
    sensibleOnTop = false;
    terminal = "tmux-256color";
    mouse = true;
    baseIndex = 1; # windows start at 1, like AeroSpace workspaces
    escapeTime = 0; # no delay after Esc in Neovim
    focusEvents = true;
    historyLimit = 50000;
    keyMode = "vi";
    extraConfig = ''
      # True colour inside kitty
      set -as terminal-features ",xterm-kitty:RGB"

      set -g renumber-windows on

      # Split in the current directory; | and - are easier to remember
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Pane navigation with hjkl
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Copy to the macOS clipboard. prefix [ enters copy mode; v selects,
      # C-v toggles a block selection, y copies. Dragging with the mouse
      # copies too, and keeps the selection on screen. Each copy and paste
      # shows a message with the size and the start of the text.
      set -s copy-command "pbcopy"
      set -g display-time 2000
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel \; display "Copied #{buffer_size} chars: #{=50:buffer_sample}"
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-no-clear \; display "Copied #{buffer_size} chars: #{=50:buffer_sample}"
      bind p paste-buffer \; display "Pasted #{buffer_size} chars"

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded"

      # Plugins (prefix + I installs, prefix + U updates)
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'catppuccin/tmux#v2.3.1'

      # Catppuccin
      set -g @catppuccin_flavor 'mocha'
      set -g @catppuccin_window_status_style 'rounded'
      set -g @catppuccin_window_text ' #W'
      set -g @catppuccin_window_current_text ' #W'
      set -g status-position top
      set -g status-left ""
      set -g status-right-length 100
      set -g status-right "#{E:@catppuccin_status_application}#{E:@catppuccin_status_session}"

      # Install TPM and the plugins on first start, then load them.
      # Keep this at the end.
      if "test ! -d ~/.config/tmux/plugins/tpm" \
        "run 'git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm && ~/.config/tmux/plugins/tpm/bin/install_plugins'"
      run '~/.config/tmux/plugins/tpm/tpm'
    '';
  };
}
