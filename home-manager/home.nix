{
  inputs,
  pkgs,
  ...
}: let
  # Paquetes de nixpkgs-unstable (para paquetes unfree más recientes)
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config = { allowUnfree = true; };
  };
in {
  home = {
    username = "dani";
    homeDirectory = "/home/dani";

    # ══════════════════════════════════════════════════════════════════════════
    # PAQUETES
    # ══════════════════════════════════════════════════════════════════════════
    packages = with pkgs; [
      steam
      blender
      vlc
      # davinci-resolve
      qownnotes
      zip
      xz
      unzip
      cargo
      gcc
      telegram-desktop
      nil

      # Editores
      unstable.code-cursor
      neovim

      # Desarrollo
      git
      gh
      curl
      gnumake
      tmux

      # Office
      libreoffice-qt

      # Shell
      antigen
      oh-my-zsh

      # KDE
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
      kdePackages.kdepim-addons
      kdePackages.dolphin-plugins
      kdePackages.kaccounts-providers
      kdePackages.accounts-qt
      kdePackages.bluedevil
    ];

    # ══════════════════════════════════════════════════════════════════════════
    # DOTFILES (desde GitHub: dortin42/dotfiles)
    # ══════════════════════════════════════════════════════════════════════════
    file = {
      ".zshrc".source = "${inputs.dotfiles}/.zshrc";
      ".p10k.zsh".source = "${inputs.dotfiles}/.p10k.zsh";
      ".config/nvim/init.lua".source = "${inputs.dotfiles}/init.lua";

      # Antigen (tu .zshrc lo espera en ~/antigen.zsh)
      "antigen.zsh".source = "${pkgs.antigen}/share/antigen/antigen.zsh";

      # Oh-My-Zsh (tu .zshrc lo espera en ~/.oh-my-zsh)
      ".oh-my-zsh".source = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
    };

    stateVersion = "25.11";
  };

  # ════════════════════════════════════════════════════════════════════════════
  # PROGRAMAS (solo habilitación, configuración viene de dotfiles)
  # ════════════════════════════════════════════════════════════════════════════
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      settings = {
        user = {
          name = "dortin42";
          email = "dortin42@gmail.com";
        };
      };
    };
  };

  # Recargar servicios automáticamente al cambiar configuración
  systemd.user.startServices = "sd-switch";
}
