{ lib, ... }:
{
  # Home Manager writes ~/.zshrc so starship, fzf and direnv can hook into the shell
  programs.zsh = {
    enable = lib.mkDefault true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # Vi mode: starts in insert mode, Esc for normal mode
    defaultKeymap = "viins";
    initContent = ''
      # Switch to normal mode right away on Esc (default waits 0.4s)
      KEYTIMEOUT=1

      # Cursor like Neovim: blinking block in insert, steady block in normal
      function zle-keymap-select zle-line-init {
        if [[ $KEYMAP == vicmd ]]; then
          printf '\e[2 q'
        else
          printf '\e[1 q'
        fi
      }
      zle -N zle-keymap-select
      zle -N zle-line-init

      # Backspace and Ctrl-W delete past where insert mode started
      bindkey -M viins '^?' backward-delete-char
      bindkey -M viins '^H' backward-delete-char
      bindkey -M viins '^W' backward-kill-word
      # A few emacs keys in insert mode
      bindkey -M viins '^A' beginning-of-line
      bindkey -M viins '^E' end-of-line
      bindkey -M viins '^U' backward-kill-line

      # v in normal mode edits the command in Neovim
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd 'v' edit-command-line
    '';
    # Put Homebrew (brew and anything it installs) on PATH
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };
}
