{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./locale.nix
    ./desktop.nix
    ./bluetooth.nix
    ./docker.nix
    ./flatpak.nix
    ./nix-ld.nix
    ./steam.nix
    ./direnv.nix
    ./users.nix
  ];
}
