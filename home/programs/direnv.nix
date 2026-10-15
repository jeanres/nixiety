{ lib, ... }:
{
  programs.direnv = {
    enable = lib.mkDefault true;
    # Cache `use flake` environments instead of rebuilding them on every cd
    nix-direnv.enable = true;
  };
}
