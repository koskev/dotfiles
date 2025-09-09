{
  settings,
  ...
}:
{
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ settings.username ];

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
}
