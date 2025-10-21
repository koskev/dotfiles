{
  pkgs,
  ...
}:

{
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  environment.systemPackages = with pkgs; [
    mate.caja
    mate.engrampa
    unrar-free

    syncthing
    wdisplays
    xorg.xrandr
    libnotify
    influxdb2-cli
    postgresql

    xterm
    unzip
    tmux
    htop

    helvum
    pavucontrol

    gnupg

    keepassxc

    element-desktop
    thunderbird
    meld
    joplin-desktop

    go
    cargo
    rustc
    clippy
    direnv
    python3

    nitrokey-app2
  ];

  xdg.portal.wlr.enable = true;
  security.polkit.enable = true;
  services = {
    gnome.gnome-keyring.enable = true;
    udisks2.enable = true;
    udev.packages = [ pkgs.nitrokey-udev-rules ];
  };

}
