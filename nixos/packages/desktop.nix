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
  ];
  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    font-awesome_6
    siji
  ];

  xdg.portal.wlr.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

}
