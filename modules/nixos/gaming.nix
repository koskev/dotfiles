_: {
  flake.modules.nixos.gaming =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    {

      environment.systemPackages = with pkgs; [
        # Gaming
        # FIXME: Workaround until https://togithub.com/NixOS/nixpkgs/issues/513246 is fixed
        (pkgs.lutris.override {
          # Intercept buildFHSEnv to modify target packages
          buildFHSEnv =
            args:
            pkgs.buildFHSEnv (
              args
              // {
                multiPkgs =
                  envPkgs:
                  let
                    # Fetch original package list
                    originalPkgs = args.multiPkgs envPkgs;

                    # Disable tests for openldap
                    customLdap = envPkgs.openldap.overrideAttrs (_: {
                      doCheck = false;
                    });
                  in
                  # Replace broken openldap with the custom one
                  builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
              }
            );
        })
        mangohud
        gamemode

      ];

      # Only allow specific unfree packages
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-unwrapped"
        ];

      hardware.steam-hardware.enable = true;
      programs = {
        gamescope.enable = true;
        steam = {
          package = pkgs.steam.override {
            # for the steam controller update to work
            # Somehow hidapi is not in the default LD_LIBRARY_PATH and the updater fails with an error due to that
            extraProfile = ''
              export LD_LIBRARY_PATH="${pkgs.hidapi}/lib:$LD_LIBRARY_PATH"
            '';
          };
          enable = true;
        };
        firejail = {
          enable = true;
          wrappedBinaries =
            let
              addBinary = package: name: {
                ${name} = {
                  executable = "${package}/bin/${name}";
                  profile = "${pkgs.firejail}/etc/firejail/${name}.profile";
                };
              };
            in
            addBinary config.programs.steam.package "steam"; # // addBinary "lutris";
        };
      };

      environment.etc = {
        "firejail/steam.local".text = ''
          #seccomp !mount,!name_to_handle_at,!pivot_root,!ptrace,!umount2
          ignore seccomp
          ignore private-tmp
          ignore private-dev
          ignore noroot

          noblacklist ''${HOME}/Games
          whitelist ''${HOME}/Games
          noblacklist ''${HOME}/Lutris
          whitelist ''${HOME}/Lutris
          noblacklist /mnt/hdd/home/kevin/Games
          whitelist /mnt/hdd/home/kevin/Games
          noblacklist /mnt/nvme_storage/SteamLibrary
          whitelist /mnt/nvme_storage/SteamLibrary

          noblacklist /tmp/.X11-unix
          whitelist /tmp/.X11-unix

          noblacklist ''${HOME}/bin
          whitelist ''${HOME}/bin

          noblacklist ''${HOME}/.factorio
          whitelist ''${HOME}/.factorio
        '';
        "firejail/lutris.local".text = ''
          ignore seccomp
          ignore noroot
          ignore private-tmp

          noblacklist ''${HOME}/.config/MangoHud
          whitelist ''${HOME}/.config/MangoHud
          noblacklist ''${HOME}/Lutris
          whitelist ''${HOME}/Lutris
          noblacklist ''${HOME}/bin
          whitelist ''${HOME}/bin
          noblacklist /tmp/.X11-unix
          whitelist /tmp/.X11-unix
          noblacklist ''${HOME}/Dokumente/Projekte/Github/GW2Overlay
          whitelist ''${HOME}/Dokumente/Projekte/Github/GW2Overlay
          noblacklist ''${HOME}/Dokumente
          whitelist ''${HOME}/.local/share/umu
          noblacklist ''${HOME}/.local/share/umu
          #seccomp !mount,!name_to_handle_at,!pivot_root,!ptrace,!umount2

          dbus-user.talk org.mozilla.*
        '';
      };
    };
}
