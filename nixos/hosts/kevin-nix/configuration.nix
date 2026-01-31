# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  settings,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../packages/gaming.nix
    ../../packages/waydroid.nix
    ../../packages/virt.nix
    ../../packages/docker.nix
    ../../../settings_option.nix # To help the lsp
  ];

  hostsettings = {
    system = {
      nixos = true;
      flake = "/home/kevin/nix";
      sensors = {
        cpu = "/dev/internal_coretemp/temp1_input";
        water = "/dev/openfanhub/temp1_input";
      };
      wireguard = {
        addresses = [
          "10.200.200.2/32"
          "fd00::2/64"
        ];
        public_key = "7ZU/0Z040UhoL0+5nG51vBlNj22RocojWUq0UHqpZRo=";
        client = {
          enable = true;
          server = "kokev";
        };
      };
    };
    users.kevin = {
      profile = "desktop";
      defaultDesktop = "hyprland";
      waybarTheme = "koskev";
    };
  };

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

      ];
      hostsToBlockString = lib.strings.join "\n" hostsToBlock;
    in
    {
      hostName = settings.hostname;

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
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
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
    DXVK_FILTER_DEVICE_NAME = "AMD Radeon RX 6700 XT (RADV NAVI22)";
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
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

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
