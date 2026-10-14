{ pkgs, ... }:

{
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };


  programs.zsh.enable = true;

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 5;
}
