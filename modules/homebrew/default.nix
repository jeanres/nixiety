{ ... }:

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

    # Every Mac gets these; a host adds its own in hosts/<host>
    casks = [
      "slack"
    ];

    # Mac App Store apps (installed via mas; you must be signed in to the App Store)
    masApps = {
      "Vimlike" = 1584519802;
    };
  };
}
