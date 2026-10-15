{ config, lib, ... }:
{
  # Nicer darwin-rebuild: build progress, package diff before switching.
  # Old generations are cleaned by nix.gc in hosts/mocha.
  programs.nh = {
    enable = lib.mkDefault true;
    flake = "${config.home.homeDirectory}/.nixiety";
  };
}
