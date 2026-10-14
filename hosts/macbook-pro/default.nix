{ pkgs, ... }:
{
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
    # Deduplicate identical files in the store
    optimise.automatic = true;
  };

  programs.zsh.enable = true;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 5;
}
