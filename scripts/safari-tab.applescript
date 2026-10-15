-- Focus the Safari tab whose URL contains `match`, or open `theURL` in a new tab.
-- Usage: osascript safari-tab.applescript '://x.com' 'https://x.com'
on run {match, theURL}
  tell application "Safari"
    activate
    repeat with w in windows
      repeat with t in tabs of w
        if (URL of t as text) contains match then
          set current tab of w to t
          set index of w to 1
          return
        end if
      end repeat
    end repeat
    if (count of windows) is 0 then
      make new document with properties {URL:theURL}
    else
      tell window 1 to set current tab to (make new tab with properties {URL:theURL})
    end if
  end tell
end run
