{ config, pkgs, ... }:
{
  # macOS settings. nix-darwin writes these one key at a time, so other
  # settings in the same domain (e.g. pinned Dock apps) are left alone.
  # Some only take effect after logging out and back in.
  system.defaults = {
    # Recommended by AeroSpace
    spaces.spans-displays = true; # turn off "Displays have separate Spaces"
    dock.expose-group-apps = true; # group windows by app in Mission Control

    dock.autohide = true;

    NSGlobalDomain = {
      # Fast key repeat, and repeat instead of the accent popup (hjkl in vim)
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;

      AppleShowAllExtensions = true;
      "com.apple.mouse.tapBehavior" = 1; # tap to click
    };

    trackpad.Clicking = true; # tap to click

    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      ShowPathbar = true;
    };

    screencapture.location = "/Users/${config.system.primaryUser}/Pictures/Screenshots";
  };

  # Installed system-wide in /Library/Fonts/Nix Fonts; macOS doesn't pick up
  # fonts Home Manager copies into ~/Library/Fonts/HomeManager.
  # Atkinson Hyperlegible Mono is designed for low vision (used by kitty).
  fonts.packages = [ pkgs.atkinson-hyperlegible-mono ];
}
