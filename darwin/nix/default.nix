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
    # Flakes only: no channels, so NIX_PATH has no channels entry (nixpkgs
    # still resolves to this flake's nixpkgs via the registry)
    channel.enable = false;
  };

  nixpkgs.config.allowUnfree = true;

  # Writes /etc/zshrc, which loads the Nix environment (PATH etc.) for zsh
  programs.zsh.enable = true;
}
