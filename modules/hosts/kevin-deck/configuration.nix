# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

_: {
  flake.modules.nixos.kevin-deck =
    {
      pkgs,
      ...
    }:

    {
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

      networking = {

        # Configure network connections interactively with nmcli or nmtui.
        networkmanager.enable = true;
        firewall.enable = false;
      };
      nixpkgs.config.allowUnfreePackages = [
        "steam"
        "steam-unwrapped"
        "steamdeck-hw-theme"
        "steam-jupiter-unwrapped"
      ];

      services = {
        desktopManager.plasma6.enable = true;
      };
      fileSystems."/mnt/sdcard" = {
        device = "/dev/mmcblk0p1";
        fsType = "btrfs";
        options = [
          # System will boot up if you don't have sd card inserted
          "nofail"
          # After booting up systemd will try mounting the sd card
          "x-systemd.automount"
        ];
      };

      jovian = {
        decky-loader = {
          # XXX: Run touch ~/.steam/steam/.cef-enable-remote-debugging or enable in developer settings
          enable = true;
        };

        devices.steamdeck = {
          enable = true;
          enableGyroDsuService = true;
          autoUpdate = false;
        };

        steam = {
          enable = true;
          autoStart = true;
          desktopSession = "plasma";
          user = "kevin";
        };
      };
      services.openssh = {
        enable = true;
      };
      users = {
        groups.plugdev = { };
        # Define a user account. Don't forget to set a password with ‘passwd’.
        users = {
          kevin = {
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB/TBxpOVXoWVtMV77vC8nUBsG0GpBj6ydjc4P59mChf kevin@kevin-arch"
            ];
            isNormalUser = true;
            extraGroups = [
              "wheel"
              "plugdev"
              "input"
            ]; # Enable ‘sudo’ for the user.
            shell = pkgs.fish;
          };
        };
      };
    };
}
