{ inputs, pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      appimage-run
      blender
      vlc
      qownnotes
      telegram-desktop
      texliveFull
      pandoc
      google-chrome
      tor-browser
    ]
    ++ [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ (with inputs.artcraft.packages.${pkgs.stdenv.hostPlatform.system}; [
      wordcraft
      gridcraft
      deckcraft
    ]);
}
