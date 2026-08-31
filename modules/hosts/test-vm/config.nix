_: {
  flake.modules.nixos.test-vm =
    { pkgs, ... }:
    {
      boot.loader.grub.device = "nodev";
      fileSystems = {
        "/" = {
          device = "/dev/vda";
          fsType = "ext4";
        };
      };
      virtualisation.vmVariant = {
        virtualisation.memorySize = 10000;
      };

      services.qemuGuest.enable = true;
      userSettings.home = "/home/admin";

      users.users.admin = {
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB/TBxpOVXoWVtMV77vC8nUBsG0GpBj6ydjc4P59mChf kevin@kevin-arch"
        ];
      };

      # Networking
      networking.hostName = "test-vm";

      # User
      users.users.admin = {
        isNormalUser = true;
        password = "admin";
        extraGroups = [ "wheel" ];
      };

      # SSH
      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
      };

      system.stateVersion = "25.11";
    };
}
