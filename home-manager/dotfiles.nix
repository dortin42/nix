{ inputs, pkgs, ... }:

{
  home.file = {
    ".zshrc".source = "${inputs.dotfiles}/.zshrc";
    ".p10k.zsh".source = "${inputs.dotfiles}/.p10k.zsh";
    ".config/nvim/init.lua".source = "${inputs.dotfiles}/init.lua";

    # El .zshrc espera antigen en ~/antigen.zsh.
    "antigen.zsh".source = "${pkgs.antigen}/share/antigen/antigen.zsh";

    # El .zshrc espera oh-my-zsh en ~/.oh-my-zsh.
    ".oh-my-zsh".source = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
  };
}
