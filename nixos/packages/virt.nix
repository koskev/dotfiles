{
  settings,
  ...
}:
{
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ settings.username ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
}
