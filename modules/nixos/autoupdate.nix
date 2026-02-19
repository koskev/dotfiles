_: {
  flake.nixosModules.autoupdate =
    {
      pkgs,
      config,
      ...
    }:
    let
      dependencies = with pkgs; [
        git
        diffutils
        nix
        gnupg
        gnugrep
      ];
    in
    {
      systemd.timers."auto-update" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*-*-* 4:00:00";
          Unit = "auto-update.service";
        };
      };

      environment.systemPackages = dependencies;

      systemd.services."auto-update" = {
        path = dependencies ++ [ config.system.build.nixos-rebuild ];
        script = ''
          set -e
          DIR=$(mktemp -d)
          pushd "$DIR"
          git clone https://github.com/koskev/dotfiles
          cd dotfiles
          git verify-commit HEAD
          nixos-rebuild --cores 1 --max-jobs 1 --flake . switch
          popd
          rm -r "$DIR"

          # The diff will return 1 if there is one
          set +e
          diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(readlink /run/current-system/{initrd,kernel,kernel-modules}) > /dev/null
          DIFF_RET=$?
          set -e
          if [ "$DIFF_RET" == "1" ]; then
            echo "Kernel changed! Rebooting..."
            reboot
          fi
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
}
