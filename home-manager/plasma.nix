{ lib, pkgs, ... }:

{
  # KRunner (Alt+F2) espera a Baloo por D-Bus si el plugin está activo.
  # Alt+Tab en Intel se retrasa al capturar miniaturas y aplicar desenfoque.
  home.activation.plasmaResponsiveness = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run() {
      $DRY_RUN_CMD ${lib.getExe' pkgs.kdePackages.kconfig "kwriteconfig6"} "$@"
    }

    run --file baloofilerc --group "Basic Settings" --key Indexing-Enabled false
    run --file krunnerrc --group Plugins --key baloorunnerEnabled false
    run --file krunnerrc --group Plugins --key baloosearchEnabled false
    run --file krunnerrc --group Plugins --key locationsEnabled false

    run --file kwinrc --group Plugins --key blurEnabled false
    run --file kwinrc --group Plugins --key highlightwindowEnabled false
    run --file kwinrc --group TabBox --key DelayTime 0
    run --file kwinrc --group TabBox --key HighlightWindows false
    run --file kwinrc --group TabBox --key LayoutName big_icons
    run --file kwinrc --group Compositing --key LatencyPolicy Low

    $DRY_RUN_CMD mkdir -p "$HOME/.config/systemd/user"
    $DRY_RUN_CMD ln -sfn /dev/null "$HOME/.config/systemd/user/plasma-baloorunner.service"
    $DRY_RUN_CMD ln -sfn /dev/null "$HOME/.config/systemd/user/kde-baloo.service"
    if [ -S "''${XDG_RUNTIME_DIR:-}/systemd/private" ]; then
      $DRY_RUN_CMD ${pkgs.systemd}/bin/systemctl --user daemon-reload || true
      $DRY_RUN_CMD ${pkgs.systemd}/bin/systemctl --user stop plasma-baloorunner.service kde-baloo.service || true
      $DRY_RUN_CMD ${lib.getExe' pkgs.kdePackages.qttools "qdbus6"} org.kde.KWin /KWin reconfigure || true
      $DRY_RUN_CMD ${lib.getExe' pkgs.kdePackages.kde-cli-tools "kquitapp6"} krunner || true
    fi
  '';
}
