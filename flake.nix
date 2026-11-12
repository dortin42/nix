{
  description = "One Flake to rule them all!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Flatpaks declarativos
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.7.0";

    # Dotfiles de GitHub
    dotfiles = {
      url = "github:dortin42/dotfiles";
      flake = false;
    };

    # Base de nix-index para flakes. El índice sigue nixos-unstable.
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, nix-index-database, ... } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        nix-flatpak.nixosModules.nix-flatpak
        nix-index-database.nixosModules.nix-index
        ./nixos/home-manager.nix
      ];
    };
  };
}
