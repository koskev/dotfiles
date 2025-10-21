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
      device = lib.mkForce "/dev/disk/by-id/nvme-E2M2_64GB_LKE243D005434_1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            name = "root";
            end = "-2G";
            content = {
              type = "btrfs";
              subvolumes = {
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = btrfsOptions;
                };
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
          swap = {
            size = "100%";
            content = {
              type = "swap";
              discardPolicy = "both";
            };
          };
        };
      };
    };
  };
}
