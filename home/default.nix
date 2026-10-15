{ ... }:
{
  # Same layout as Home Manager's own modules (targets/ is at the top level)
  imports = [
    ./programs # programs.*
    ./services # services.*
  ];
}
