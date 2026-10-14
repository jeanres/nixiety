{ ... }:
{
  # --cmd cd makes `cd` use zoxide (and adds `cdi` for interactive picking)
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };
}
