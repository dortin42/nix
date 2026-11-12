{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.applet-window-buttons6
    kdePackages.zanshin
    kdePackages.ark
    kdePackages.kcalc
    kdePackages.yakuake
    kmymoney
    kdePackages.kontact
    kdePackages.korganizer
    krita
    kdePackages.kdenlive
    kdePackages.audiotube
    kdePackages.blinken
    kdePackages.kalgebra
    kdePackages.artikulate
    kdePackages.ktorrent
    kdePackages.kmail-account-wizard
    kdePackages.kdepim-addons
    kdePackages.kmail
    kdePackages.kaddressbook
    kdePackages.dolphin-plugins
    kdePackages.kaccounts-providers
    kdePackages.accounts-qt
    kdePackages.bluedevil
  ];
}
