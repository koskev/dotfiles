{
  lib,
  ...
}:
let

  btrfsOptions = [
    "noatime"
    "compress-force=zstd:3"
    "ssd"
    "space_cache=v2"
  ];
in
{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkForce "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            size = "1M";
            type = "EF02"; # for grub MBR
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "btrfs";
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = btrfsOptions;
                };
                "@root_snapshots" = {
                  mountpoint = "/.snapshots";
                };
              };
            };
          };
        };
      };
    };
  };
}
