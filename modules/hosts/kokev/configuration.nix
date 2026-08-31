# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

_: {
  flake.modules.nixos.kokev = _: {
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
            #root = defaultConfig "/";
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
    };

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
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
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "letsencrypt@kokev.de";
      };
    };
  };
}
