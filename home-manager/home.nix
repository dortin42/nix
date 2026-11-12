{ ... }:

{
  imports = [
    ./dotfiles.nix
    ./git.nix
    ./packages/tools.nix
    ./packages/apps.nix
    ./packages/kde.nix
    ./packages/python.nix
    ./plasma.nix
  ];

  home.username = "dani";
  home.homeDirectory = "/home/dani";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
