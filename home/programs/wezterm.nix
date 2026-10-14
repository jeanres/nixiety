{ ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        color_scheme = "Catppuccin Mocha",
        font_size = 14.0,
        -- No title bar; keep resize handles so AeroSpace can tile it
        window_decorations = "RESIZE",
        enable_tab_bar = false,
      }
    '';
  };
}
