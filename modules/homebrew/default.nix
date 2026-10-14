{ pkgs, ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [
    ];

    casks = [
      "bambu-studio"
      "slack"
      "raspberry-pi-imager"
    ];

    # Mac App Store apps (installed via mas; you must be signed in to the App Store)
    masApps = {
      "Vimlike" = 1584519802;
    };
  };
}
