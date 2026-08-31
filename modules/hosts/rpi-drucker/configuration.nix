# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

_: {
  flake.modules.nixos.rpi-drucker = _: {

    # Override kernel to prevent building it. We don't need the rpi kernel anyways
    # Only required if using rpi hardware config
    #boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    zramSwap.enable = true;

    networking = {
      networkmanager.enable = true;
    };

    services.openssh = {
      enable = true;
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        22
      ];
    };
  };
}
