_: {
  flake.modules.nixos.virt =
    {
      config,
      ...
    }:
    {
      programs.virt-manager.enable = true;

      users.groups.libvirtd.members = [ config.userSettings.userName ];

      virtualisation = {
        libvirtd.enable = true;

        podman = {
          enable = true;
        };
        containers.storage.settings = {
          storage = {
            driver = "btrfs";
          };

        };

        spiceUSBRedirection.enable = true;
      };
    };
}
