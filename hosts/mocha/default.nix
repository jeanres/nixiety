{
  # Personal MacBook Pro
  networking = {
    hostName = "mocha";
    computerName = "mocha"; # shown in Finder, AirDrop and Sharing
    localHostName = "mocha"; # Bonjour: mocha.local
  };

  # Added to the shared casks in darwin/homebrew
  homebrew.casks = [
    "bambu-studio"
    "raspberry-pi-imager"
    "whatsapp"
  ];
}
