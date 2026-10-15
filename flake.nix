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

      # Shared modules plus ./hosts/<host>. Throughout, default.nix is
      # nix-darwin and home.nix is Home Manager
      mkHost =
        host: user:
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            ./hosts/${host}
            ./targets/darwin
            {
              system.primaryUser = user;
              users.users.${user}.home = "/Users/${user}";
              system.stateVersion = 5;
            }
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} = {
                  imports = [
                    ./home
                    ./targets/darwin/macos/home.nix
                    ./hosts/${host}/home.nix
                  ];
                  home.stateVersion = "26.11";
                };
              };
            }
          ];
        };
    in
    {
      # darwin-rebuild switch --flake .#<host> (or: make switch)
      darwinConfigurations = {
        mocha = mkHost "mocha" "jeanreswanepoel"; # personal
        # Work Mac. Change the user if the work account is named differently
        latte = mkHost "latte" "jeanreswanepoel";
      };

      # nix fmt: format every .nix file with nixfmt
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
