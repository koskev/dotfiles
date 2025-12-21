{
  pkgs,
  config,
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
      # Exporting the path since git needs the gpg binary in it
      export PATH="$PATH:${pkgs.git}/bin:${config.system.build.nixos-rebuild}/bin:${pkgs.gnupg}/bin";
      DIR=$(mktemp -d)
      pushd $DIR
      git clone https://github.com/koskev/dotfiles
      cd dotfiles
      git verify-commit HEAD
      nixos-rebuild --flake . switch
      popd
      rm -r $DIR
      DIFF_OUTPUT=$(diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(readlink /run/current-system/{initrd,kernel,kernel-modules}))
      if ! [ -z $DIFF_OUTPUT ]; then
        echo "Kernel changed! Rebooting..."
        reboot
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
