{ lib, ... }:

let
  firmwarePartition = lib.recursiveUpdate {
    # label = "FIRMWARE";
    priority = 1;

    type = "0700"; # Microsoft basic data
    attributes = [
      0 # Required Partition
    ];

    size = "512M";
    content = {
      type = "filesystem";
      format = "vfat";
      # mountpoint = "/boot/firmware";
      mountOptions = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
  };

  espPartition = lib.recursiveUpdate {
    # label = "ESP";

    type = "EF00"; # EFI System Partition (ESP)
    attributes = [
      2 # Legacy BIOS Bootable, for U-Boot to find extlinux config
    ];

    size = "1024M";
    content = {
      type = "filesystem";
      format = "vfat";
      # mountpoint = "/boot";
      mountOptions = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
        "umask=0077"
      ];
    };
  };

  btrfsOptions = [
    "noatime"
    "compress-force=zstd:3"
    "ssd"
    "space_cache=v2"
  ];

in
{

  # https://nixos.wiki/wiki/Btrfs#Scrubbing
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  disko.devices.disk.main = {
    type = "disk";
    device = lib.mkForce "/dev/mmcblk0";

    content = {
      type = "gpt";
      partitions = {

        FIRMWARE = firmwarePartition {
          label = "FIRMWARE";
          content.mountpoint = "/boot/firmware";
        };

        ESP = espPartition {
          label = "ESP";
          content.mountpoint = "/boot";
        };

        system = {
          type = "8305"; # Linux ARM64 root (/)

          size = "100%";
          content = {
            type = "btrfs";
            subvolumes = {
              "@root" = {
                mountpoint = "/";
                mountOptions = btrfsOptions;
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = btrfsOptions;
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = btrfsOptions;
              };
            };
          };
        }; # system

        swap = {
          type = "8200"; # Linux swap

          size = "1G";
          content = {
            type = "swap";
            # zram's swap will be used first, and this one only
            # used when the system is under pressure enough that zram and
            # "regular" swap above didn't work
            # https://github.com/systemd/systemd/issues/16708#issuecomment-1632592375
            # (set zramSwap.priority > btrfs' .swapvol priority > this priority)
            priority = 2;
          };
        };
      };
    };
  }; # disko.devices.disk.main
}
