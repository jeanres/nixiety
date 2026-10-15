{ lib, ... }:
{
  # --cmd cd makes `cd` use zoxide (and adds `cdi` for interactive picking)
  programs.zoxide = {
    enable = lib.mkDefault true;
    options = [ "--cmd cd" ];
  };
}
