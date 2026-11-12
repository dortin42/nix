{ ... }:

{
  services.flatpak = {
    enable = true;
    packages = [
      "net.waterfox.waterfox"
    ];
    update.onActivation = true;
  };
}
