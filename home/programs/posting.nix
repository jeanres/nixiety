{ ... }:
{
  # TUI for HTTP APIs (like Postman). Collections are folders of YAML
  # requests; run `posting --collection <dir>` to use a project's.
  programs.posting = {
    enable = true;
    settings.theme = "catppuccin-mocha";
  };
}
