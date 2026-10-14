{ ... }:
{
  # Same layout as Home Manager's own modules
  imports = [
    ./programs # programs.*
    ./services # services.*
    ./targets/darwin # macOS-only settings
  ];
}
