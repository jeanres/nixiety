{ ... }:
{
  # Zsh integration aliases ls (and ll, la, lt, lla) to eza
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}
