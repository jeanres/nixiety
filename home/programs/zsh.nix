{ ... }:
{
  # Home Manager writes ~/.zshrc so starship, fzf and direnv can hook into the shell
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # Put Homebrew (brew and anything it installs) on PATH
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };
}
