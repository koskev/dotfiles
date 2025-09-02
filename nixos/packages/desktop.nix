{
  pkgs,
  ...
}:

{
  programs = {
    gnupg.agent.enable = true;
    sway.enable = true;
  };

  environment.systemPackages = with pkgs; [
    sway
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
  ];

  xdg.portal.wlr.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

}
