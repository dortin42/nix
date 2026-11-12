{ pkgs, ... }:

{
  # Linker estándar para el AppImage de Cursor y su actualizador.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      fuse
      e2fsprogs
      stdenv.cc.cc.lib
      glib
      gtk3
      nspr
      nss
      at-spi2-core
      cairo
      pango
      gdk-pixbuf
      dbus
      cups
      expat
      zlib
      libffi
      sqlite
      readline
      ncurses
      alsa-lib
      libpulseaudio
      libdrm
      libgbm
      libGL
      mesa
      vulkan-loader
      libxkbcommon
      wayland
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxcb
      libxshmfence
    ];
  };
}
