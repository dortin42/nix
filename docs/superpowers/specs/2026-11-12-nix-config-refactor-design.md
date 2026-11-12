# Refactor de la configuración NixOS

Fecha: 2026-11-12

Refactor de un solo host (`nixos`) y un solo usuario (`dani`). No hay opciones propias ni abstracción para más máquinas. El sistema queda igual, salvo las bajas de la sección «Código que desaparece»: git sigue por `programs.git`, y antigen y oh-my-zsh siguen por `home.file`.

## Fuera de alcance

- `nixos/hardware-configuration.nix` no se edita. Es el resultado de `nixos-generate-config`.
- No se actualizan revisiones de `nixpkgs`, home-manager, nix-flatpak ni dotfiles.

## Árbol resultante

```
flake.nix
flake.lock
nixos/configuration.nix
nixos/hardware-configuration.nix
nixos/system.nix
nixos/locale.nix
nixos/desktop.nix
nixos/bluetooth.nix
nixos/docker.nix
nixos/flatpak.nix
nixos/nix-ld.nix
nixos/steam.nix
nixos/direnv.nix
nixos/users.nix
nixos/home-manager.nix
home-manager/home.nix
home-manager/dotfiles.nix
home-manager/git.nix
home-manager/packages/tools.nix
home-manager/packages/apps.nix
home-manager/packages/kde.nix
home-manager/packages/python.nix
```

Se borra `init.lua` de la raíz del repo. Neovim sigue saliendo de `inputs.dotfiles`.

## flake

`flake.nix` conserva `nixpkgs` (`nixos-26.05`), `home-manager` (`release-26.05`, `follows = "nixpkgs"`), `nix-flatpak` (`v0.7.0`), `dotfiles` (`github:dortin42/dotfiles`, `flake = false`) y `nix-index-database` (`github:nix-community/nix-index-database`, `follows = "nixpkgs"`). La base de `nix-index` sigue el canal unstable: un comando ausente puede apuntar a un paquete un poco más nuevo que el de 26.05.

`artcraft` (`github:J0schu/artcraft.nix`) trae WordCraft, GridCraft y DeckCraft. Esos tres no están en `nixos-26.05`. El flake empaqueta los AppImage oficiales y no sigue el `nixpkgs` del sistema.

`zen-browser` (`github:0xc000022070/zen-browser-flake`) instala el canal beta de Zen. Tampoco está en nixpkgs y no sigue el `nixpkgs` del sistema: el binario necesita las librerías de la revisión con la que se empaqueta.

Se elimina el input `nixpkgs-unstable`.

`outputs` sigue pasando `specialArgs = { inherit inputs; }`. Los módulos del sistema son:

- `./nixos/configuration.nix`
- `home-manager.nixosModules.home-manager`
- `nix-flatpak.nixosModules.nix-flatpak`
- `nix-index-database.nixosModules.nix-index`
- `./nixos/home-manager.nix`

En `flake.lock` se quita el nodo `nixpkgs-unstable` y la clave `nixpkgs-unstable` de `nodes.root.inputs`. El resto de nodos, hashes y revisiones quedan igual. No se ejecuta `nix flake update`.

## NixOS

Ningún módulo define opciones nuevas. `configuration.nix` es `{ ... }:` y solo importa:

- `./hardware-configuration.nix`
- `./system.nix`
- `./locale.nix`
- `./desktop.nix`
- `./bluetooth.nix`
- `./docker.nix`
- `./flatpak.nix`
- `./nix-ld.nix`
- `./steam.nix`
- `./direnv.nix`
- `./users.nix`

Se eliminan los comentarios y las opciones comentadas de la plantilla de NixOS (proxy, wireless, OpenSSH, firewall, GnuPG, mtr, libinput, JACK, media-session, `environment.systemPackages` vacío).

### system.nix

- `boot.loader.systemd-boot.enable = true`
- `boot.loader.efi.canTouchEfiVariables = true`
- `networking.hostName = "nixos"`
- `networking.networkmanager.enable = true`
- `nixpkgs.config.allowUnfree = true`
- `nix.settings.experimental-features = [ "nix-command" "flakes" ]`
- `environment.localBinInPath = true`
- `system.stateVersion = "26.05"`

### locale.nix

- `time.timeZone = "Europe/Madrid"`
- `i18n.defaultLocale = "en_US.UTF-8"`
- `i18n.extraLocaleSettings` con `LC_ADDRESS`, `LC_IDENTIFICATION`, `LC_MEASUREMENT`, `LC_MONETARY`, `LC_NAME`, `LC_NUMERIC`, `LC_PAPER`, `LC_TELEPHONE` y `LC_TIME` en `es_ES.UTF-8`

### desktop.nix

- `services.xserver.enable = true`
- `services.displayManager.sddm.enable = true`
- `services.desktopManager.plasma6.enable = true`
- `services.xserver.xkb.layout = "us"` y `variant = ""`
- `services.printing.enable = true`
- `services.pulseaudio.enable = false`
- `security.rtkit.enable = true`
- `services.pipewire.enable`, `alsa.enable`, `alsa.support32Bit` y `pulse.enable` en `true`
- `programs.firefox.enable = true`
- `programs.kdeconnect.enable = true`
- `programs.partition-manager.enable = true`
- `programs.kde-pim.enable = true`

### bluetooth.nix

Los mismos valores actuales, con indentación uniforme:

- `hardware.bluetooth.enable = true`
- `hardware.bluetooth.powerOnBoot = true`
- `settings.General.Experimental = true`
- `settings.General.FastConnectable = true`
- `settings.Policy.AutoEnable = true`

Se omiten los comentarios largos copiados del manual.

### docker.nix

- `virtualisation.docker.enable = true`
- `virtualisation.docker.rootless.enable = false`
- `virtualisation.docker.daemon.settings.dns = [ "1.1.1.1" "8.8.8.8" ]`
- `environment.systemPackages` incluye `pkgs.docker-compose` (Compose 5, comando `docker-compose`).

No se cargan `ip_tables` ni `iptable_nat`. Esos módulos eran para compartir carpetas con WinApps. `compose.yaml` no forma parte del repo.

### nix-ld.nix

`programs.nix-ld.enable = true`. `libraries`: `fuse`, `e2fsprogs`, `stdenv.cc.cc.lib`, `glib`, `gtk3`, `nspr`, `nss`, `at-spi2-core`, `cairo`, `pango`, `gdk-pixbuf`, `dbus`, `cups`, `expat`, `zlib`, `libffi`, `sqlite`, `readline`, `ncurses`, `alsa-lib`, `libpulseaudio`, `libdrm`, `libgbm`, `libGL`, `mesa`, `vulkan-loader`, `libxkbcommon`, `wayland`, `libx11`, `libxcomposite`, `libxdamage`, `libxext`, `libxfixes`, `libxrandr`, `libxcb`, `libxshmfence`.

No se activa `programs.appimage.binfmt`. `appimage-run` sigue en los paquetes de home-manager para otros AppImages.

### steam.nix

`programs.steam.enable = true`. Activa las librerías de 32 bits y el hardware de Steam. Steam deja de estar en `home.packages`.

`programs.gamemode.enable = true`.

### direnv.nix

`programs.direnv.enable = true`. `nix-direnv` queda activo, que es el valor por defecto del módulo de NixOS. El hook de zsh entra por `/etc/zshrc`, así que vale con el `.zshrc` de los dotfiles.

El módulo `nix-index-database` activa `programs.nix-index` y desactiva `programs.command-not-found`.

### flatpak.nix

- `services.flatpak.enable = true`
- `services.flatpak.packages = [ ]`
- `services.flatpak.update.onActivation = true`

### users.nix

Firma `{ pkgs, ... }:`.

- `users.users.dani`: `isNormalUser`, `description = "dani"`, `extraGroups = [ "networkmanager" "wheel" "docker" ]`, `shell = pkgs.zsh`, `packages = [ pkgs.kdePackages.kate ]`
- `programs.zsh.enable = true`

Kate permanece en el perfil de usuario de NixOS. No pasa a home-manager. Thunderbird comentado no se migra.

### home-manager.nix

Módulo de NixOS, firma `{ inputs, ... }:`. Recibe `inputs` por `specialArgs` del flake. No es configuración de usuario:

- `home-manager.useGlobalPkgs = true`
- `home-manager.useUserPackages = true`
- `home-manager.extraSpecialArgs = { inherit inputs; }`
- `home-manager.users.dani = import ../home-manager/home.nix`

## home-manager

`home.nix` solo fija la identidad e importa el resto:

- `home.username = "dani"`
- `home.homeDirectory = "/home/dani"`
- `home.stateVersion = "26.05"`
- `programs.home-manager.enable = true`
- `systemd.user.startServices = "sd-switch"`
- imports: `./dotfiles.nix`, `./git.nix`, `./packages/tools.nix`, `./packages/apps.nix`, `./packages/kde.nix`, `./packages/python.nix`, `./plasma.nix`

`plasma.nix` desactiva la indexación de Baloo y su plugin en KRunner, y deja Alt+Tab en iconos grandes, sin desenfoque y con latencia baja del compositor. No desinstala KMail ni Kontact.

### dotfiles.nix

Firma `{ inputs, pkgs, ... }:`. `home.file`, con las mismas rutas de ahora:

- `.zshrc` y `.p10k.zsh` desde `inputs.dotfiles`
- `.config/nvim/init.lua` desde `${inputs.dotfiles}/init.lua`
- `antigen.zsh` desde `${pkgs.antigen}/share/antigen/antigen.zsh`
- `.oh-my-zsh` desde `${pkgs.oh-my-zsh}/share/oh-my-zsh`

### git.nix

`programs.git.enable = true`, con `settings.user.name = "dortin42"` y `settings.user.email = "dortin42@gmail.com"`.

`programs.delta.enable = true` y `programs.delta.enableGitIntegration = true`. Delta es el pager de `git diff`, `log`, `show` y `blame`.

Los cuatro módulos de paquetes tienen firma `{ pkgs, ... }:` y asignan `home.packages = with pkgs; [ ... ];`.

### packages/tools.nix

`zip`, `xz`, `unzip`, `ripgrep`, `fd`, `fzf`, `bat`, `eza`, `zoxide`, `jq`, `wl-clipboard`, `cargo`, `gcc`, `nil`, `nixfmt`, `nix-output-monitor`, `neovim`, `android-tools`, `scrcpy`, `gh`, `curl`, `gnumake`, `tmux`, `uv`, `ruff`, `lazydocker`.

### packages/apps.nix

`appimage-run`, `blender`, `vlc`, `qownnotes`, `telegram-desktop`, `texliveFull`, `pandoc`, `google-chrome`, `tor-browser`, el paquete `default` de `inputs.zen-browser`, más `wordcraft`, `gridcraft` y `deckcraft` desde `inputs.artcraft.packages`.

### packages/kde.nix

`kdePackages.applet-window-buttons6`, `kdePackages.zanshin`, `kdePackages.ark`, `kdePackages.kcalc`, `kdePackages.yakuake`, `kmymoney`, `kdePackages.kontact`, `kdePackages.korganizer`, `krita`, `kdePackages.kdenlive`, `kdePackages.audiotube`, `kdePackages.blinken`, `kdePackages.kalgebra`, `kdePackages.artikulate`, `kdePackages.ktorrent`, `kdePackages.kmail-account-wizard`, `kdePackages.kdepim-addons`, `kdePackages.kmail`, `kdePackages.kaddressbook`, `kdePackages.dolphin-plugins`, `kdePackages.kaccounts-providers`, `kdePackages.accounts-qt`, `kdePackages.bluedevil`.

`kdePackages.kdepim-addons` aparece una sola vez.

### packages/python.nix

Un `python3.withPackages` con: `ipykernel`, `notebook`, `jupyterlab`, `pyzmq`, `numpy`, `pandas`, `matplotlib`, `scikit-learn`, `scipy`, `seaborn`, `statsmodels`, `sympy`, `tensorflow`, `keras`, `torch`, `wandb`. Ese entorno global se queda como está. Las librerías nuevas de un proyecto se instalan con `uv` en su `.venv`, sin editar este archivo.

`pandoc` no entra en ese entorno. El CLI sigue en `packages/apps.nix`.

Las cuatro listas se concatenan en `home.packages`.

## Código que desaparece

- El input `nixpkgs-unstable` y el `let unstable = import inputs.nixpkgs-unstable ...` de `home.nix`. Ningún paquete lo usaba.
- `steam` dentro de `home.packages`. Lo instala `programs.steam`.
- `git` dentro de `home.packages`. `programs.git` ya instala git.
- `antigen` y `oh-my-zsh` dentro de `home.packages`. Siguen en el store a través de `home.file`.
- El `init.lua` local. No está referenciado por el flake.
- La segunda entrada de `kdePackages.kdepim-addons`.
- `pandoc` dentro del entorno Python.
- Comentarios de plantilla y paquetes comentados (`thunderbird`, `davinci-resolve`).
- `libreoffice-qt`. Lo sustituyen WordCraft, GridCraft y DeckCraft.
- `librewolf-bin` y `mullvad-browser`. El navegador de cada día es Zen; Tor queda para ocultar la IP.

`allowUnfree` del import de unstable desaparece con ese import. El `nixpkgs.config.allowUnfree` del sistema sigue cubriendo los paquetes de usuario porque `home-manager.useGlobalPkgs = true`.

## Comprobación

`nix eval --raw .#nixosConfigurations.nixos.config.networking.hostName` devuelve `nixos`.

`nix build .#nixosConfigurations.nixos.config.system.build.toplevel --dry-run` evalúa el sistema completo, home-manager incluido, sin construir el cierre.

Una búsqueda en el repo no encuentra `nixpkgs-unstable`, `inputs.nixpkgs-unstable` ni un `init.lua` en la raíz.
