{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
 home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Jeanres-MacBook-Pro
    darwinConfigurations."Jeanres-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

      modules = [ 
./modules/homebrew
./systems/development
 {
            users.users."jeanreswanepoel".home = "/Users/jeanreswanepoel";
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."jeanreswanepoel" =
              { pkgs, ... }:
              {
                imports = [ ./home ];
                home.stateVersion = "26.11";
              };
          }
 ];
    };
  };
}
