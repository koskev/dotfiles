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
    rofi
    waybar
    slurp
    grim
    wl-clipboard-rs
    mate.caja
    syncthing
    wdisplays
    xorg.xrandr
    libnotify
    dunst

    xterm
    unzip
    tmux
    htop

    helvum
    pavucontrol

    gnupg

    keepassxc

    # Music
    mpd
    mpc
    cantata

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
