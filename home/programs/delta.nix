{ lib, ... }:
{
  programs.delta = {
    enable = lib.mkDefault true;
    enableGitIntegration = true;
  };
}
