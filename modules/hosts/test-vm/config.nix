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

      services.qemuGuest.enable = true;
      userSettings.home = "/home/admin";
      time.timeZone = "Europe/Amsterdam";

      i18n.defaultLocale = "en_DK.UTF-8";
      console = {
        font = "Lat2-Terminus16";
        keyMap = "de";
      };
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
