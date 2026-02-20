# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  settings,
  inputs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    inputs.jovian.nixosModules.default

    ./hardware-configuration.nix
    ./disk-config.nix

    #    ../../packages/gaming.nix
    #    ../../packages/waydroid.nix
    #    ../../packages/virt.nix
    #    ../../packages/docker.nix
  ];

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
    hostName = settings.hostname;

    # Configure network connections interactively with nmcli or nmtui.
    networkmanager.enable = true;
    firewall.enable = false;
  };
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
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
  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };
  users = {
    groups.plugdev = { };
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
      # Needed for remote deployment
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB/TBxpOVXoWVtMV77vC8nUBsG0GpBj6ydjc4P59mChf kevin@kevin-arch"
        ];
      };
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = settings.stateVersion; # Did you read the comment?
}
