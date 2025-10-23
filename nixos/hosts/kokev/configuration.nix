# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  settings,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disk-config.nix
    ./nginx.nix
    ./services.nix
    ../../packages/docker.nix
  ];
  services = {
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
        };

    };
  };

  boot.loader = {
    grub = {
      enable = true;
    };
  };
  services.qemuGuest.enable = true;

  networking = {
    nameservers = [
      "46.38.225.230"
      "46.38.252.230"
    ];
    interfaces.ens3 = {
      ipv6.addresses = [
        {
          address = "2a03:4000:58:fcd::1";
          prefixLength = 64;
        }
      ];
      ipv4.addresses = [
        {
          address = "202.61.194.167";
          prefixLength = 22;
        }
      ];
    };
    defaultGateway = {
      address = "202.61.192.1";
      interface = "ens3";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
    hostName = settings.hostname;
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };
  users.users.root = {
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB/TBxpOVXoWVtMV77vC8nUBsG0GpBj6ydjc4P59mChf kevin@kevin-arch"
    ];
  };

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [
      22
      25
      80
      443
      465
      993
    ];
    allowedUDPPorts = [
      settings.system.wireguard.server.listen_port
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "letsencrypt@kokev.de";
    };
  };

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
