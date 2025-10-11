{
  pkgs,
  ...
}:
{
  systemd.timers."auto-update" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 4:00:00";
      Unit = "auto-update.service";
    };
  };

  systemd.services."auto-update" = {
    script = ''
      set -e
      DIR=$(mktemp -d)
      pushd $DIR
      ${pkgs.git}/bin/git clone https://github.com/koskev/dotfiles
      cd dotfiles
      git verify-commit HEAD
      nixos-rebuild --flake . switch
      popd
      rm -r $DIR
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
