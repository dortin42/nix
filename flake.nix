{
  description = "One Flake to rule them all!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flatpaks declarativos
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";

    # Dotfiles de GitHub
    dotfiles = {
      url = "github:dortin42/dotfiles";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        nix-flatpak.nixosModules.nix-flatpak
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.dani = import ./home-manager/home.nix;
        }
      ];
    };
  };
}
