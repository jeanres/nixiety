{
  description = "nix-darwin + Home Manager config for Jeanre's MacBook Pro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";
      host = "Jeanres-MacBook-Pro";
      user = "jeanreswanepoel";
    in
    {
      # darwin-rebuild switch --flake .#Jeanres-MacBook-Pro (or: make switch)
      darwinConfigurations.${host} = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./hosts/macbook-pro
          ./modules/homebrew
          ./modules/macos
          {
            system.primaryUser = user;
            users.users.${user}.home = "/Users/${user}";
          }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = {
                imports = [ ./home ];
                home.stateVersion = "26.11";
              };
            };
          }
        ];
      };

      # nix fmt: format every .nix file with nixfmt
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
