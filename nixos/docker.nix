{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    rootless.enable = false;
    daemon.settings = {
      "dns" = [ "1.1.1.1" "8.8.8.8" ];
    };
  };

  environment.systemPackages = [ pkgs.docker-compose ];
}
