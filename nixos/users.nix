{ pkgs, ... }:

{
  users.users.dani = {
    isNormalUser = true;
    description = "dani";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = [ pkgs.kdePackages.kate ];
  };

  programs.zsh.enable = true;
}
