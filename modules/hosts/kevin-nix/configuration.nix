# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

_: {
  flake.modules.nixos.kevin-nix =
    {
      pkgs,
      lib,
      ...
    }:

    {

      programs.gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 10;
          };

          # Warning: GPU optimisations have the potential to damage hardware
          gpu = {
            apply_gpu_optimisations = "accept-responsibility";
            gpu_device = 2;
            amd_performance_level = "high";
          };

          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
      programs.fish.enable = true;
      # For Cross building flakes
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

      hardware.bluetooth = {
        enable = true;
      };
      services = {
        blueman.enable = true;
        pipewire = {
          enable = true;
          pulse.enable = true;
        };
        snapper = {
          configs =
            let
              defaultConfig = path: {
                SUBVOLUME = path;
                TIMELINE_CREATE = true;
                TIMELINE_CLEANUP = true;
              };

            in
            {
              home = defaultConfig "/home";
              nvme_storage = defaultConfig "/mnt/nvme_storage";
            };

        };
      };

      sops.gnupg.home = "/home/kevin/.gnupg";

      boot.loader = {
        efi = {
          efiSysMountPoint = "/boot/efi";
          canTouchEfiVariables = true;
        };
        grub = {
          efiSupport = true;
          enable = true;
          device = "nodev";
        };
      };

      networking =
        let
          hostsToBlock = map (entry: "127.0.0.1 ${entry}") [
            # According to some reports this site is now full of AI child porn. Better be safe and block it completely on the system level.
            # Long overdue anyways
            "x.com"
            "twitter.com"
            "t.co"
            "twimg.com"
            "ads-twitter.com"
            "pscp.tv"
            "twtrdns.net"
            "twttr.com"
            "periscope.tv"
            "tweetdeck.com"
            "twitpic.com"
            "twitter.co"
            "twitterinc.com"
            "twitteroauth.com"
            "twitterstat.us"

            # Cheap shitty AI "copy" of Wikipedia with a nazi bias
            "grokipedia.com"

          ];
          hostsToBlockString = lib.strings.join "\n" hostsToBlock;
        in
        {

          # Configure network connections interactively with nmcli or nmtui.
          networkmanager.enable = true;
          # To make waydroid work again
          nftables.enable = true;
          extraHosts = ''
            192.168.1.17 kubernetes.lan
            ${hostsToBlockString}
          '';
          firewall.enable = false;
        };

      users.groups.plugdev = { };
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.kevin = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "plugdev"
          "input"
          "video"
          "render"
          "i2c"
          "gamemode"
        ]; # Enable ‘sudo’ for the user.
        shell = pkgs.zsh;
      };

      services.udev = {
        extraRules = ''
          ACTION=="add", SUBSYSTEM=="hwmon", RUN+="/bin/sh -c 'chgrp -R plugdev /sys/$devpath && chmod -R g+w /sys/$devpath'"
          ACTION=="add", SUBSYSTEM=="hwmon", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c10", ATTRS{manufacturer}=="OpenFanHub",  RUN+="/bin/sh -c 'ln -s /sys$devpath /dev/openfanhub'"
          ACTION=="remove", SUBSYSTEM=="hwmon", ATTRS{idVendor}=="1b1c", ATTRS{idProduct}=="0c10", ATTRS{manufacturer}=="OpenFanHub",  RUN+="/bin/sh -c 'rm /dev/openfanhub'"

          # internal coretemp stable path
          ACTION=="change", SUBSYSTEM=="hwmon", ATTRS{temp13_label}=="Core 39",  RUN+="/bin/sh -c 'ln -s /sys$devpath /dev/internal_coretemp'"
        '';
      };

      environment.sessionVariables = {
        VDPAU_DRIVER = "radeonsi";
        LIBVA_DRIVER_NAME = "radeonsi";
        # Some games were selecting the wrong GPU. This forces DXVK to use the correct one
        DXVK_FILTER_DEVICE_NAME = "AMD Radeon";
      };
    };
}
