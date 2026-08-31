# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

_: {
  flake.modules.nixos.kevin-laptop =
    {
      pkgs,
      ...
    }:

    {
      services = {
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
              root = defaultConfig "/";
              home = defaultConfig "/home";
            };

        };
      };

      #sops.gnupg.home = "/home/kevin/.gnupg";

      boot.loader = {
        grub = {
          efiSupport = false;
          enable = true;
          device = "/dev/sda";
        };
      };

      networking = {

        # Configure network connections interactively with nmcli or nmtui.
        networkmanager.enable = true;
        # To make waydroid work again
        nftables.enable = true;
      };

      users.groups.plugdev = { };
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users = {
        kevin = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "plugdev"
            "input"
            "video"
            "render"
          ]; # Enable ‘sudo’ for the user.
          shell = pkgs.fish;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB/TBxpOVXoWVtMV77vC8nUBsG0GpBj6ydjc4P59mChf kevin@kevin-arch"
          ];
        };
      };

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      services.openssh = {
        enable = true;
      };

      networking.firewall.enable = true;
    };
}
