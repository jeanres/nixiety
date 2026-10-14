{ ... }:
{
  services.jankyborders = {
    enable = true;
    settings = {
      style = "round";
      width = 6.0;
      hidpi = "on";
      # Catppuccin Mocha: mauve / surface1
      active_color = "0xffcba6f7";
      inactive_color = "0xff45475a";
    };
  };
}
