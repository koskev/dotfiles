# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

_: {
  flake.modules.nixos.rpi-server =
    {
      pkgs,
      config,
      ...
    }:
    {

      # Override kernel to prevent building it. We don't need the rpi kernel anyways
      # Only required if using rpi hardware config
      #boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
      zramSwap.enable = true;

      networking = {
        networkmanager.enable = true;
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

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          22
        ];
      };
      system.stateVersion = config.hostSettings.stateVersion; # Did you read the comment?
    };
}
