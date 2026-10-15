{ config, ... }:
{
  # Nicer darwin-rebuild: build progress, package diff before switching.
  # Old generations are cleaned by nix.gc in hosts/macbook-pro.
  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/.nixiety";
  };
}
