{ ... }:
{
  # nix-darwin (the whole Mac). The Home Manager part is macos/home.nix.
  imports = [
    ./nix # Nix (Lix), GC, store optimisation
    ./homebrew # casks and Mac App Store apps
    ./macos # macOS settings and fonts
  ];
}
