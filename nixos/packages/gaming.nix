{
  pkgs,
  lib,
  ...
}:

{

  environment.systemPackages = with pkgs; [
    # Gaming
    lutris
  ];

  # Only allow specific unfree packages
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
    ];
  programs.steam.enable = true;

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      steam = {
        executable = "${lib.getBin pkgs.steam}/bin/steam";
        profile = "${pkgs.firejail}/etc/firejail/steam.profile";
      };
      lutris = {
        executable = "${lib.getBin pkgs.lutris}/bin/lutris";
        profile = "${pkgs.firejail}/etc/firejail/lutris.profile";
      };
    };
  };

  environment.etc = {
    "firejail/steam.local".text = ''
      #seccomp !mount,!name_to_handle_at,!pivot_root,!ptrace,!umount2
      ignore seccomp
      ignore private-tmp
      ignore noroot

      noblacklist ''${HOME}/Games
      whitelist ''${HOME}/Games
      noblacklist /mnt/hdd/home/kevin/Games
      whitelist /mnt/hdd/home/kevin/Games
      noblacklist /mnt/nvme_storage/SteamLibrary
      whitelist /mnt/nvme_storage/SteamLibrary

      noblacklist /tmp/.X11-unix
      whitelist /tmp/.X11-unix

      noblacklist ''${HOME}/bin
      whitelist ''${HOME}/bin

      noblacklist ''${HOME}/.factorio
      whitelist ''${HOME}/.factorio
    '';
    "firejail/lutris.local".text = ''
      ignore seccomp
      ignore noroot
      ignore private-tmp

      noblacklist ''${HOME}/.config/MangoHud
      whitelist ''${HOME}/.config/MangoHud
      noblacklist ''${HOME}/Lutris
      whitelist ''${HOME}/Lutris
      noblacklist ''${HOME}/bin
      whitelist ''${HOME}/bin
      noblacklist /tmp/.X11-unix
      whitelist /tmp/.X11-unix
      noblacklist ''${HOME}/Dokumente/Projekte/Github/GW2Overlay
      whitelist ''${HOME}/Dokumente/Projekte/Github/GW2Overlay
      noblacklist ''${HOME}/Dokumente
      whitelist ''${HOME}/.local/share/umu
      noblacklist ''${HOME}/.local/share/umu
      #seccomp !mount,!name_to_handle_at,!pivot_root,!ptrace,!umount2

      dbus-user.talk org.mozilla.*
    '';
  };
}
