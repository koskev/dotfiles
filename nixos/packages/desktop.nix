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
    waybar
    slurp
    grim
    mate.caja
    syncthing
    wdisplays
    xorg.xrandr
    libnotify
    swaynotificationcenter
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
