{ pkgs, ... }:

{
  home.packages = with pkgs; [
    appimage-run
    blender
    vlc
    qownnotes
    telegram-desktop
    texliveFull
    pandoc
    google-chrome
    libreoffice-qt
  ];
}
