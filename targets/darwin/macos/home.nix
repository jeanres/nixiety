{ lib, ... }:
{
  # Desktop stacks: group desktop files by kind.
  # Uses -dict-add so the rest of DesktopViewSettings (icon size etc.) is kept;
  # system.defaults would overwrite the whole dict.
  home.activation.desktopStacks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! /usr/libexec/PlistBuddy -c "Print :DesktopViewSettings:GroupBy" \
        "$HOME/Library/Preferences/com.apple.finder.plist" 2>/dev/null | grep -qx Kind; then
      run /usr/bin/defaults write com.apple.finder DesktopViewSettings -dict-add GroupBy Kind
      run /usr/bin/killall Finder || true
    fi
  '';

  # Screenshots are saved here (location set in default.nix)
  home.activation.screenshotsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/Pictures/Screenshots"
  '';
}
