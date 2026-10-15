{ ... }:
{
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    settings = {
      # Atkinson Hyperlegible Mono (installed in modules/macos, designed for
      # low vision). Medium weight: slightly thicker strokes hold up better when blurry
      # Fonts are picked by PostScript name: by family, kitty picks the
      # variable font and ends up with ExtraLight.
      font_family = "postscript_name=AtkinsonHyperlegibleMono-Medium";
      bold_font = "postscript_name=AtkinsonHyperlegibleMono-Bold";
      italic_font = "postscript_name=AtkinsonHyperlegibleMono-MediumItalic";
      bold_italic_font = "postscript_name=AtkinsonHyperlegibleMono-BoldItalic";
      font_size = 16;
      modify_font = "cell_height 110%"; # a little more room between lines
      # No title bar; keep resize handles so AeroSpace can tile it
      hide_window_decorations = "titlebar-only";
      tab_bar_style = "hidden";
      # No bell: no sound, no flash, no Dock bounce
      enable_audio_bell = false;
      visual_bell_duration = 0;
      window_alert_on_bell = false;
      # Space around the text, so tmux's and Neovim's status lines don't
      # touch the window edge (top/bottom left/right, in pt)
      window_padding_width = "10 14";

      # Cursor: a peach block that fades in and out and leaves a trail
      # when it jumps, so it's easy to find
      cursor_shape = "block";
      cursor = "#fab387"; # peach
      cursor_text_color = "#11111b"; # crust
      cursor_blink_interval = "0.7 ease-in-out";
      cursor_stop_blinking_after = 0; # keep blinking
      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;
      cursor_trail_color = "#fab387";

      # High-contrast selection
      selection_background = "#b4befe"; # lavender
      selection_foreground = "#11111b";

      # Selecting with the mouse copies; hold Shift to select over apps
      # that use the mouse (tmux, Neovim)
      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";
    };
    mouseBindings = {
      # Right click pastes
      "right press" = "ungrabbed paste_from_clipboard";
      # Plain click only selects; Cmd+click opens links
      "left click" = "ungrabbed mouse_handle_click selection prompt";
      "cmd+left click" = "ungrabbed mouse_handle_click link";
    };
    keybindings = {
      # Label every URL, path, hash, etc. on screen; type a label to copy it
      "cmd+shift+space" = "kitten hints --type word --program @";
    };
  };
}
