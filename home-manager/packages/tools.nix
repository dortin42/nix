{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zip
    xz
    unzip
    ripgrep
    fd
    fzf
    bat
    eza
    zoxide
    jq
    wl-clipboard
    cargo
    gcc
    nil
    nixfmt
    nix-output-monitor
    neovim
    android-tools
    scrcpy
    gh
    curl
    gnumake
    tmux
    uv
    ruff
    lazydocker
  ];
}
