{ lib, ... }:
{
  # Zsh integration aliases ls (and ll, la, lt, lla) to eza
  programs.eza = {
    enable = lib.mkDefault true;
    enableZshIntegration = true;
  };
}
