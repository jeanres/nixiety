{ ... }:
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Jeanre Swanepoel";
      email = "jeanres@icloud.com";
    };
    settings.init.defaultBranch = "main";
  };
}
